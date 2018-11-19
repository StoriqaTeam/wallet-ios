//
//  SendTransactionService.swift
//  Wallet
//
//  Created by Tata Gri on 19/11/2018.
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
    
    init(sendNetworkProvider: SendTransactionNetworkProviderProtocol,
         userDataStoreService: UserDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         accountsUpdater: AccountsUpdaterProtocol,
         txnUpdater: TransactionsUpdaterProtocol) {
        self.userDataStoreService = userDataStoreService
        self.sendNetworkProvider = sendNetworkProvider
        self.authTokenProvider = authTokenProvider
        self.accountsUpdater = accountsUpdater
        self.txnUpdater = txnUpdater
    }
    
    func sendTransaction(transaction: Transaction,
                         fromAccount: String,
                         completion: @escaping (Result<String?>) -> Void) {
        let userId = userDataStoreService.getCurrentUser().id
        
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.sendNetworkProvider.send(
                    transaction: transaction,
                    userId: userId,
                    fromAccount: fromAccount,
                    authToken: token,
                    queue: .main,
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


