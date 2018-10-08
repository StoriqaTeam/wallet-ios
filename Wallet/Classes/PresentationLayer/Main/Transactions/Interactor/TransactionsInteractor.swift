//
//  TransactionsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum TransactionFilter: Int {
    case all, send, receive
}


class TransactionsInteractor {
    weak var output: TransactionsInteractorOutput!
    private let transactions: [Transaction]
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
}


// MARK: - TransactionsInteractorInput

extension TransactionsInteractor: TransactionsInteractorInput {
    
    func getFilteredTransacitons(index: Int) -> [Transaction] {
        guard let filter = TransactionFilter(rawValue: index) else { return [] }
        let filteredTransactions = filterTransactions(filter)
        return filteredTransactions
    }
    
    func getTransactions() -> [Transaction] {
        return transactions
    }
    
}


// MARK: - Private methods

extension TransactionsInteractor {
    private func filterTransactions(_ filter: TransactionFilter) -> [Transaction] {
        switch filter {
        case .all:
            return transactions
        case .send:
            return transactions.filter { $0.direction == .send }
        case .receive:
            return transactions.filter { $0.direction == .receive }
        }
    }
}
