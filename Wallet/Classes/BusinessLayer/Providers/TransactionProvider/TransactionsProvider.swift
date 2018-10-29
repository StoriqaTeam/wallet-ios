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
    func setTxnUpdaterChannel(_ channel: TxnUpadteChannel)
}

class TransactionsProvider: TransactionsProviderProtocol {
    private let dataStore: TransactionDataStoreServiceProtocol
    private var txnUpadateChannelOutput: TxnUpadteChannel?
    
    init(transactionDataStoreService: TransactionDataStoreServiceProtocol) {
        self.dataStore = transactionDataStoreService
    }
    
    func setTxnUpdaterChannel(_ channel: TxnUpadteChannel) {
        guard txnUpadateChannelOutput == nil else {
            return
        }
        
        self.txnUpadateChannelOutput = channel
        
        dataStore.observe { [weak self] (transactions) in
            log.debug("Transactions updated: \(transactions.map { $0.id })", "count: \(transactions.count)")
            self?.txnUpadateChannelOutput?.send(transactions)
        }
    }
    
    func getAllTransactions() -> [Transaction] {
        let allTrxs = dataStore.getTransactions()
        return allTrxs
    }
    
    func transactionsFor(account: Account) -> [Transaction] {
        let allTrxs = dataStore.getTransactions()
        let accAddress = account.accountAddress
        let accountTrxs = allTrxs.filter {
            return $0.toAddress == accAddress || $0.fromAddress.contains(accAddress)
        }
        return accountTrxs
    }
    
    func getLastTransactionTime() -> TimeInterval {
        let allTrxs = dataStore.getTransactions()
        
        guard !allTrxs.isEmpty else {
            return 0
        }
        
        let sorted = sortedTransaction(allTrxs)
    
        if var lastPending = sorted.lastIndex(where: { $0.status == .pending }) {
            if lastPending == sorted.count - 1 {
                return 0
            }
            
            lastPending += 1
            return sorted[lastPending].createdAt.timeIntervalSince1970
        }
        
        let firstTrxTime = sorted.first?.createdAt.timeIntervalSince1970 ?? 0
        return firstTrxTime
    }
}


// MARK: Private methods

extension TransactionsProvider {
    private func sortedTransaction(_ txs: [Transaction]) -> [Transaction] {
        let sorted = txs.sorted { $0.createdAt > $1.createdAt }
        return sorted
    }
}
