//
//  AccountsUpdater.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsUpdaterProtocol {
    func update()
}

class AccountsUpdater: AccountsUpdaterProtocol {
    
    private let accountsNetworkProvider: AccountsNetworkProviderProtocol
    private let accountsDataStore: AccountsDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    
    private var isUpdating = false
    
    init(accountsNetworkProvider: AccountsNetworkProviderProtocol,
         accountsDataStore: AccountsDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         userDataStoreService: UserDataStoreServiceProtocol) {
        
        self.accountsNetworkProvider = accountsNetworkProvider
        self.accountsDataStore = accountsDataStore
        self.authTokenProvider = authTokenProvider
        self.signHeaderFactory = signHeaderFactory
        self.userDataStoreService = userDataStoreService
    }
    
    func update() {
        guard !isUpdating else {
            return
        }
        
        isUpdating = true
        
        let user = userDataStoreService.getCurrentUser()
        let currentEmail = user.email
        let userId = user.id
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.accountsNetworkProvider.getAccounts(
                    authToken: token,
                    userId: userId,
                    queue: .main,
                    signHeader: signHeader) { [weak self] (result) in
                        switch result {
                        case .success(let accounts):
                            log.debug(accounts.map { $0.id })
                            self?.accountsDataStore.update(accounts)
                        case .failure(let error):
                            log.warn(error.localizedDescription)
                        }
                        
                        self?.isUpdating = false
                }
            case .failure(let error):
                log.warn(error.localizedDescription)
                self?.isUpdating = false
            }
        }
    }
}
