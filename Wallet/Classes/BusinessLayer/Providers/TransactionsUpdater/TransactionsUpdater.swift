//
//  TransactionsUpdater.swift
//  Wallet
//
//  Created by Tata Gri on 26/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionsUpdaterProtocol {
    func update(userId: Int)
}

class TransactionsUpdater: TransactionsUpdaterProtocol {
    
    private let provider: TransactionsProviderProtocol
    private let networkProvider: TransactionsNetworkProviderProtocol
    private let dataStore: TransactionDataStoreServiceProtocol
    private let defaults: DefaultsProviderProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    
    private var isUpdating = false
    private var lastTxTime: TimeInterval!
    private var userId: Int!
    private var offset = 0
    private let limit = 2
    
    init(transactionsProvider: TransactionsProviderProtocol,
         transactionsNetworkProvider: TransactionsNetworkProviderProtocol,
         transactionsDataStoreService: TransactionDataStoreServiceProtocol,
         defaultsProvider: DefaultsProviderProtocol,
         authTokenProvider: AuthTokenProviderProtocol) {
        self.provider = transactionsProvider
        self.networkProvider = transactionsNetworkProvider
        self.dataStore = transactionsDataStoreService
        self.defaults = defaultsProvider
        self.authTokenProvider = authTokenProvider
    }
    
    func update(userId: Int) {
        guard !isUpdating else {
            return
        }
        
        isUpdating = true
        
        self.userId = userId
        
        if let unfinishedTime = defaults.lastTxTimastamp {
            lastTxTime = unfinishedTime
        } else {
            lastTxTime = provider.getLastTransactionTime()
            defaults.lastTxTimastamp = lastTxTime
        }
        
        update()
    }
    
}


// MARK: Private methods

extension TransactionsUpdater {
    
    private func update() {
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
        networkProvider.getTransactions(
            authToken: token,
            userId: userId,
            offset: offset,
            limit: limit,
            queue: .main,
            completion: { [weak self] (result) in
                switch result {
                case .success(let txs):
                    log.debug(txs.map { $0.id })
                    self?.transactionsLoaded(txs)
                case .failure(let error):
                    log.error(error.localizedDescription)
                    self?.isUpdating = false
                }
            }
        )
    }
    
    private func transactionsLoaded(_ txs: [Transaction]) {
        dataStore.save(txs)
        
        if txs.count < limit ||
            isTxAlreadyLoaded(txs.first!) {
            isUpdating = false
            defaults.lastTxTimastamp = nil
        } else {
            offset += limit
            update()
        }
    }
    
    private func isTxAlreadyLoaded(_ transaction: Transaction) -> Bool {
        return lastTxTime >= transaction.createdAt.timeIntervalSince1970
    }
    
}
