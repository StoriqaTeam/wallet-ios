//
//  TransactionsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


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
