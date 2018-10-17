//
//  TransactionsDateFilter.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionDateFilterProtocol {
    
    var fromDate: Date? { get set }
    var toDate: Date? { get set }
    
    func resetFilter()
    
    func applyFilter(for transactions: [TransactionDisplayable]) -> [TransactionDisplayable]
    func canApplyFilter() -> Bool
}


class TransactionDateFilter: TransactionDateFilterProtocol {
    
    var fromDate: Date?
    var toDate: Date?
    
    
    func resetFilter() {
        fromDate = nil
        toDate = nil
    }
    
    func applyFilter(for transactions: [TransactionDisplayable]) -> [TransactionDisplayable] {
        guard let fromDate = fromDate else { return transactions }
        guard let toDate = toDate else { return transactions }
        
        return filterByDate(transactions: transactions, fromDate: fromDate, toDate: toDate)
    }
    
    func canApplyFilter() -> Bool {
        guard let fromDate = fromDate else { return false }
        guard let toDate = toDate else { return false }
        
        return fromDate < toDate
    }
}


// MARK: - Private methods

extension TransactionDateFilter {
    
    private func filterByDate(transactions: [TransactionDisplayable],
                              fromDate: Date,
                              toDate: Date) -> [TransactionDisplayable] {
        
        var filtered = [TransactionDisplayable]()
        
        for transaction in transactions {
            let timestamp = transaction.transaction.timestamp
            let largerThenLowerBound = timestamp >= fromDate
            let lessThenUpperBound = timestamp <= toDate
            
            if largerThenLowerBound && lessThenUpperBound {
                filtered.append(transaction)
            }
        }
        
        return filtered
    }
}
