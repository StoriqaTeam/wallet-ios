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
    func sendExchangeTransaction(transaction: Transaction,
                                 fromAccount: String,
                                 value: Decimal,
                                 currency: Currency,
                                 exchangeId: String,
                                 exchangeRate: Decimal,
                                 completion: @escaping (Result<String?>) -> Void)
}

class SendTransactionService: SendTransactionServiceProtocol {
    private let sendNetworkProvider: SendTransactionNetworkProviderProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let accountsUpdater: AccountsUpdaterProtocol
    private let txnUpdater: TransactionsUpdaterProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    
    private let retryCount = 3
    
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
        
        authTokenProvider.currentAuthToken { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let token):
                strongSelf.sendTransaction(retryCount: strongSelf.retryCount,
                                           authToken: token,
                                           userId: userId,
                                           email: currentEmail,
                                           transaction: transaction,
                                           fromAccount: fromAccount,
                                           completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func sendExchangeTransaction(transaction: Transaction,
                                 fromAccount: String,
                                 value: Decimal,
                                 currency: Currency,
                                 exchangeId: String,
                                 exchangeRate: Decimal,
                                 completion: @escaping (Result<String?>) -> Void) {
        
        let user = userDataStoreService.getCurrentUser()
        let userId = user.id
        let currentEmail = user.email
        
        authTokenProvider.currentAuthToken { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let token):
                strongSelf.sendExchangeTransaction(authToken: token,
                                                   userId: userId,
                                                   email: currentEmail,
                                                   transaction: transaction,
                                                   fromAccount: fromAccount,
                                                   value: value,
                                                   currency: currency,
                                                   exchangeId: exchangeId,
                                                   exchangeRate: exchangeRate,
                                                   completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// MARK: Private methods

extension SendTransactionService {
    private func sendTransaction(retryCount: Int,
                                 authToken: String,
                                 userId: Int,
                                 email: String,
                                 transaction: Transaction,
                                 fromAccount: String,
                                 completion: @escaping (Result<String?>) -> Void) {
        let retryCount = retryCount - 1
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: email)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        sendNetworkProvider.send(
            transaction: transaction,
            userId: userId,
            fromAccount: fromAccount,
            authToken: authToken,
            queue: .main,
            signHeader: signHeader,
            completion: { [weak self] (result) in
                switch result {
                case .success:
                    self?.accountsUpdater.update()
                    self?.txnUpdater.update()
                    
                    completion(.success(nil))
                case .failure(let error):
                    if retryCount > 0,
                        case DefaultNetworkProviderError.internalServer = error {
                        self?.sendTransaction(retryCount: retryCount,
                                              authToken: authToken,
                                              userId: userId,
                                              email: email,
                                              transaction: transaction,
                                              fromAccount: fromAccount,
                                              completion: completion)
                        return
                    }
                    
                    completion(.failure(error))
                }
            }
        )
        
    }
    
    
    private func sendExchangeTransaction(authToken: String,
                                         userId: Int,
                                         email: String,
                                         transaction: Transaction,
                                         fromAccount: String,
                                         value: Decimal,
                                         currency: Currency,
                                         exchangeId: String,
                                         exchangeRate: Decimal,
                                         completion: @escaping (Result<String?>) -> Void) {
        
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: email)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        sendNetworkProvider.sendExchange(
            transaction: transaction,
            userId: userId,
            fromAccount: fromAccount,
            value: value,
            currency: currency,
            authToken: authToken,
            queue: .main,
            signHeader: signHeader,
            exchangeId: exchangeId,
            exchangeRate: exchangeRate,
            completion: { [weak self] (result) in
                
                log.warn("Send: Exchange rate id: \(exchangeId)")
                log.warn("Send: From currency: \(fromAccount)")
                log.warn("\n\n")
                
                switch result {
                case .success:
                    self?.accountsUpdater.update()
                    self?.txnUpdater.update()
                    completion(.success(nil))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
}
