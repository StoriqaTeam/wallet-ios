//
//  SendTransactionService.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SendTransactionServiceProtocol {
    func sendTransaction(transaction: Transaction,
                         fromAccount: String,
                         completion: @escaping (Result<String?>) -> Void)
}

class SendTransactionService: SendTransactionServiceProtocol {
    private let sendNetworkProvider: SendTransactionNetworkProviderProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let accountsUpdater: AccountsUpdaterProtocol
    private let txnUpdater: TransactionsUpdaterProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    init(sendNetworkProvider: SendTransactionNetworkProviderProtocol,
         userDataStoreService: UserDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         accountsUpdater: AccountsUpdaterProtocol,
         txnUpdater: TransactionsUpdaterProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol) {
        self.userDataStoreService = userDataStoreService
        self.sendNetworkProvider = sendNetworkProvider
        self.authTokenProvider = authTokenProvider
        self.accountsUpdater = accountsUpdater
        self.txnUpdater = txnUpdater
        self.signHeaderFactory = signHeaderFactory
    }
    
    func sendTransaction(transaction: Transaction,
                         fromAccount: String,
                         completion: @escaping (Result<String?>) -> Void) {
        let user = userDataStoreService.getCurrentUser()
        let userId = user.id
        let currentEmail = user.email
        
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
                self?.sendNetworkProvider.send(
                    transaction: transaction,
                    userId: userId,
                    fromAccount: fromAccount,
                    authToken: token,
                    queue: .main,
                    signHeader: signHeader,
                    completion: { [weak self] (result) in
                        switch result {
                        case .success:
                            self?.accountsUpdater.update(userId: userId)
                            self?.txnUpdater.update(userId: userId)
                            
                            completion(.success(nil))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                )
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


