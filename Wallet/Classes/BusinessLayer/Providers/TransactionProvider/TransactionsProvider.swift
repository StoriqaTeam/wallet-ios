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
    func setObserver(_ observer: TransactionsProviderDelegate)
}

protocol TransactionsProviderDelegate: class {
    func transactionsDidUpdate(_ transactions: [Transaction])
}

class TransactionsProvider: TransactionsProviderProtocol {
    private weak var observer: TransactionsProviderDelegate?
    private let dataStore: TransactionDataStoreServiceProtocol
    
    init(transactionDataStoreService: TransactionDataStoreServiceProtocol) {
        self.dataStore = transactionDataStoreService
    }
    
    func setObserver(_ observer: TransactionsProviderDelegate) {
        self.observer = observer
        
        dataStore.observe { [weak self] (transactions) in
            self?.observer?.transactionsDidUpdate(transactions)
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
