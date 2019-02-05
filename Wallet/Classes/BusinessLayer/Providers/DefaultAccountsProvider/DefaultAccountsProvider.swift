//
//  DefaultAccountsProvider.swift
//  Wallet
//
//  Created by Storiqa on 02/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol DefaultAccountsProviderProtocol {
    func create(completion: @escaping (Result<String?>) -> Void)
}

class DefaultAccountsProvider: DefaultAccountsProviderProtocol {
    
    private let userDataStore: UserDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let createAccountsNetworkProvider: CreateAccountNetworkProviderProtocol
    private let accountsDataStore: AccountsDataStoreServiceProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    init(userDataStore: UserDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         createAccountsNetworkProvider: CreateAccountNetworkProviderProtocol,
         accountsDataStore: AccountsDataStoreServiceProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        
        self.userDataStore = userDataStore
        self.authTokenProvider = authTokenProvider
        self.createAccountsNetworkProvider = createAccountsNetworkProvider
        self.accountsDataStore = accountsDataStore
        self.signHeaderFactory = signHeaderFactory
    }
    
    func create(completion: @escaping (Result<String?>) -> Void) {
        let userId = userDataStore.getCurrentUser().id
        
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.create(userId: userId, authToken: token, completion: completion)
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
    
}

// MARK: Private methods

extension DefaultAccountsProvider {
    private func create(userId: Int, authToken: String, completion: @escaping (Result<String?>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        let stqUUID = UUID().uuidString
        let ethUUID = UUID().uuidString
        let btcUUID = UUID().uuidString
        
        createAccount(group: dispatchGroup, authToken: authToken, userId: userId, uuid: stqUUID, currency: .stq)
        createAccount(group: dispatchGroup, authToken: authToken, userId: userId, uuid: ethUUID, currency: .eth)
        createAccount(group: dispatchGroup, authToken: authToken, userId: userId, uuid: btcUUID, currency: .btc)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            let accounts = self?.accountsDataStore.getAllAccounts() ?? []
            
            guard !accounts.isEmpty else {
                completion(Result.failure(DefaultAccountsProviderError()))
                return
            }
            
            completion(Result.success(nil))
        }
    }
    
    private func createAccount(group: DispatchGroup, authToken: String, userId: Int, uuid: String, currency: Currency) {
        group.enter()
        
        let currentEmail = userDataStore.getCurrentUser().email
        let signHeader: SignHeader
        
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
        } catch {
            log.error(error.localizedDescription)
            group.leave()
            return
        }
        
        createAccountsNetworkProvider.createAccount(
            authToken: authToken,
            userId: userId,
            id: uuid,
            currency: currency,
            name: "\(currency.ISO) account",
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                switch result {
                case .success(let account):
                    self?.accountsDataStore.save(account)
                case .failure(let error):
                    log.warn(error.localizedDescription)
                }
                group.leave()
        }
    }
}

struct DefaultAccountsProviderError: LocalizedError, Error {
    var errorDescription: String? {
        return "No accounts created"
    }
}
