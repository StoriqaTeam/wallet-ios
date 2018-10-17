//
//  TransactionsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum DirectionFilter: Int {
    case all, send, receive
}


class TransactionsInteractor {
    weak var output: TransactionsInteractorOutput!
    private let transactions: [TransactionDisplayable]
    private let transactionsDateFilter: TransactionDateFilterProtocol
    
    init(transactions: [TransactionDisplayable], transactionsDateFilter: TransactionDateFilterProtocol) {
        self.transactions = transactions
        self.transactionsDateFilter = transactionsDateFilter
    }
}


// MARK: - TransactionsInteractorInput

extension TransactionsInteractor: TransactionsInteractorInput {
    func getTransactionDateFilter() -> TransactionDateFilterProtocol {
        return self.transactionsDateFilter
    }
    
    
    func getFilteredTransacitons(index: Int) -> [TransactionDisplayable] {
        guard let filter = DirectionFilter(rawValue: index) else { return [] }
        let filteredTransactions = filterTransactionsByDirection(filter)
        return filteredTransactions
    }
    
    func getTransactions() -> [TransactionDisplayable] {
        let dateFilteredTransactions = transactionsDateFilter.applyFilter(for: transactions)
        return dateFilteredTransactions
    }
    
}


// MARK: - Private methods

extension TransactionsInteractor {
    private func filterTransactionsByDirection(_ filter: DirectionFilter) -> [TransactionDisplayable] {
        let dateFilteredTransactions = transactionsDateFilter.applyFilter(for: transactions)
        switch filter {
        case .all:
            return dateFilteredTransactions
        case .send:
            return dateFilteredTransactions.filter { $0.direction == .send }
        case .receive:
            return dateFilteredTransactions.filter { $0.direction == .receive }
        }
    }
}
