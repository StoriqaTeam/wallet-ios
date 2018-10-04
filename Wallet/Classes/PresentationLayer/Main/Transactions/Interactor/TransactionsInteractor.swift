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
    private var transactionDataManager: TransactionsDataManager!
    private let transactions: [Transaction]
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
}


// MARK: - TransactionsInteractorInput

extension TransactionsInteractor: TransactionsInteractorInput {
    
    func filterTransacitons(index: Int) {
        guard let filter = TransactionFilter(rawValue: index) else { return }
        let filteredTransactions = filterTransactions(filter)
        if filteredTransactions.isEmpty { return }
        transactionDataManager.updateTransactions(filteredTransactions)
    }
    
    func getTransactions() -> [Transaction] {
        return transactions
    }
    
    func setTransactionDataManagerDelegate(_ delegate: TransactionsDataManagerDelegate) {
        transactionDataManager.delegate = delegate
    }
    
    func createTransactionsDataManager(with tableView: UITableView) {
        
        let txDataManager = TransactionsDataManager(transactions: transactions)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
        
        if transactions.isEmpty {
            transactionDataManager.updateEmpty(placeholderImage: UIImage(named: "noTxs")!,
                                               placeholderText: "")
        }
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
