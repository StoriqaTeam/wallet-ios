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
    private var lastTrxTime: TimeInterval!
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
        self.userId = userId
        
        if let unfinishedTime = defaults.lastTrxTimastamp {
            lastTrxTime = unfinishedTime
        } else {
            lastTrxTime = provider.getLastTransactionTime()
            defaults.lastTrxTimastamp = lastTrxTime
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
                case .success(let trxs):
                    log.debug(trxs.map { $0.id })
                    self?.transactionsLoaded(trxs)
                case .failure(let error):
                    log.error(error.localizedDescription)
                    self?.isUpdating = false
                }
            }
        )
    }
    
    private func transactionsLoaded(_ trxs: [Transaction]) {
        dataStore.save(trxs)
        
        if trxs.count < limit ||
            isTxAlreadyLoaded(trxs.first!) {
            isUpdating = false
            defaults.lastTrxTimastamp = nil
        } else {
            offset += limit
            update()
        }
    }
    
    private func isTxAlreadyLoaded(_ transaction: Transaction) -> Bool {
        print("lastTrxTime: \(lastTrxTime!)", "trx: \(transaction.createdAt.timeIntervalSince1970)")
        
        return lastTrxTime >= transaction.createdAt.timeIntervalSince1970
    }
    
}
