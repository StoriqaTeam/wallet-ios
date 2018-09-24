//
//  LastTransactionsDataManager.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol LastTransactionsDataManagerDelegate: class {
    
}


class LastTransactionsDataManager: NSObject {
    
    weak var delegate: LastTransactionsDataManagerDelegate!
    private var lastTransactionsTableView: UITableView!
    private var transactions: [Transaction]
    private let kTransactionCellId = "transactionCell"
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    func setTableView(_ view: UITableView) {
        lastTransactionsTableView = view
        lastTransactionsTableView.dataSource = self
    }
    
    func updateTransactions(_ transactions: [Transaction]) {
        self.transactions = transactions
        self.lastTransactionsTableView.reloadData()
    }
    
    func registerXib() {
        let nib = UINib(nibName: "TransactionCell", bundle: nil)
        lastTransactionsTableView.register(nib, forCellReuseIdentifier: kTransactionCellId)
    }

}


// MARK: UITableViewDataSource

extension LastTransactionsDataManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let transaction = transactions[indexPath.row]
       let cell = lastTransactionsTableView.dequeueReusableCell(withIdentifier: kTransactionCellId, for: indexPath) as! TransactionTableViewCell
        cell.configureWith(transaction: transaction)
        return cell
    }
}
