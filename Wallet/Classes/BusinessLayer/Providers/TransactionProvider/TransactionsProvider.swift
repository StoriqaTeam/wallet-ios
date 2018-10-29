//
//  TransactionsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionsProviderProtocol: class {
    func getAllTransactions() -> [Transaction]
    func transactionsFor(account: Account) -> [Transaction]
    func getLastTransactionTime() -> TimeInterval
    func setTxsUpdaterChannel(_ channel: TxsUpdateChannel)
}

class TransactionsProvider: TransactionsProviderProtocol {
    private let dataStore: TransactionDataStoreServiceProtocol
    private var txsUpadateChannelOutput: TxsUpdateChannel?
    
    init(transactionDataStoreService: TransactionDataStoreServiceProtocol) {
        self.dataStore = transactionDataStoreService
    }
    
    func setTxsUpdaterChannel(_ channel: TxsUpdateChannel) {
        guard txsUpadateChannelOutput == nil else {
            return
        }
        
        self.txsUpadateChannelOutput = channel
        
        dataStore.observe { [weak self] (transactions) in
            log.debug("Transactions updated: \(transactions.map { $0.id })", "count: \(transactions.count)")
            self?.txsUpadateChannelOutput?.send(transactions)
        }
    }
    
    func getAllTransactions() -> [Transaction] {
        let allTxs = dataStore.getTransactions()
        return allTxs
    }
    
    func transactionsFor(account: Account) -> [Transaction] {
        let allTxs = dataStore.getTransactions()
        let accAddress = account.accountAddress
        let accountTxs = allTxs.filter {
            return $0.toAddress == accAddress || $0.fromAddress.contains(accAddress)
        }
        return accountTxs
    }
    
    func getLastTransactionTime() -> TimeInterval {
        let allTxs = dataStore.getTransactions()
        
        guard !allTxs.isEmpty else {
            return 0
        }
        
        let sorted = sortedTransaction(allTxs)
    
        if var lastPending = sorted.lastIndex(where: { $0.status == .pending }) {
            if lastPending == sorted.count - 1 {
                return 0
            }
            
            lastPending += 1
            return sorted[lastPending].createdAt.timeIntervalSince1970
        }
        
        let firstTxTime = sorted.first?.createdAt.timeIntervalSince1970 ?? 0
        return firstTxTime
    }
}


// MARK: Private methods

extension TransactionsProvider {
    private func sortedTransaction(_ txs: [Transaction]) -> [Transaction] {
        let sorted = txs.sorted { $0.createdAt > $1.createdAt }
        return sorted
    }
}
