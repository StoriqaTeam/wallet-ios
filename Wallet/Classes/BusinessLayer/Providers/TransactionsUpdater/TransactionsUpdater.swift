//
//  TransactionsUpdater.swift
//  Wallet
//
//  Created by Storiqa on 26/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionsUpdaterProtocol {
    func update()
}

class TransactionsUpdater: TransactionsUpdaterProtocol {
    
    private let provider: TransactionsProviderProtocol
    private let networkProvider: TransactionsNetworkProviderProtocol
    private let dataStore: TransactionDataStoreServiceProtocol
    private let defaults: DefaultsProviderProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    private let receivedTransactionProvider: ReceivedTransactionProviderProtocol
    
    private var prevTxs = [Transaction]()
    private var isUpdating = false
    private var lastTxTime: TimeInterval!
    private var offset = 0
    private let limit: Int
    
    init(transactionsProvider: TransactionsProviderProtocol,
         transactionsNetworkProvider: TransactionsNetworkProviderProtocol,
         transactionsDataStoreService: TransactionDataStoreServiceProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         defaultsProvider: DefaultsProviderProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         userDataStoreService: UserDataStoreServiceProtocol,
         receivedTransactionProvider: ReceivedTransactionProviderProtocol,
         limit: Int = 50) {
        self.provider = transactionsProvider
        self.networkProvider = transactionsNetworkProvider
        self.dataStore = transactionsDataStoreService
        self.defaults = defaultsProvider
        self.authTokenProvider = authTokenProvider
        self.signHeaderFactory = signHeaderFactory
        self.userDataStoreService = userDataStoreService
        self.receivedTransactionProvider = receivedTransactionProvider
        self.limit = limit
    }
    
    func update() {
        guard !isUpdating else {
            return
        }
        
        isUpdating = true
        offset = 0
        prevTxs = provider.getAllTransactions()
        
        if let unfinishedTime = defaults.lastTxTimastamp {
            lastTxTime = unfinishedTime
        } else {
            lastTxTime = provider.getLastTransactionTime()
            defaults.lastTxTimastamp = lastTxTime
        }
        
        updateTransactions()
    }
    
}


// MARK: Private methods

extension TransactionsUpdater {
    
    private func updateTransactions() {
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.getTransactions(token: token)
                
            case .failure(let error):
                log.error(error.localizedDescription)
                self?.isUpdating = false
            }
        }
    }
    
    private func getTransactions(token: String) {
        let user = userDataStoreService.getCurrentUser()
        let currentEmail = user.email
        let userId = user.id
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: currentEmail)
        } catch {
            isUpdating = false
            log.error(error.localizedDescription)
            return
        }
        
        
        networkProvider.getTransactions(
            authToken: token,
            userId: userId,
            offset: offset,
            limit: limit,
            queue: .main,
            signHeader: signHeader,
            completion: { [weak self] (result) in
                switch result {
                case .success(let txs):
                    log.debug("Txn count: \(txs.count)")
                    log.debug("Txn received: \(txs.map { $0.id })")
                    self?.transactionsLoaded(txs)
                case .failure(let error):
                    log.error(error.localizedDescription)
                    self?.finish()
                }
            }
        )
    }
    
    private func transactionsLoaded(_ txs: [Transaction]) {
        dataStore.save(txs)
        
        if txs.count < limit ||
            isTxAlreadyLoaded(txs.last!) {
            finish()
            defaults.lastTxTimastamp = nil
        } else {
            offset += limit
            updateTransactions()
        }
    }
    
    private func isTxAlreadyLoaded(_ transaction: Transaction) -> Bool {
        return lastTxTime >= transaction.createdAt.timeIntervalSince1970
    }
    
    private func finish() {
        isUpdating = false
        
        guard !defaults.isFirstTransactionsLoad else {
            defaults.isFirstTransactionsLoad = false
            return
        }
        
        let newTxs = provider.getAllTransactions()
        receivedTransactionProvider.resolve(oldTxs: prevTxs, newTxs: newTxs)
    }
    
}
