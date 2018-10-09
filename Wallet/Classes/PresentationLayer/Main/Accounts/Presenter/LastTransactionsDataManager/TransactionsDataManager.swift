//
//  TransactionsDataManager.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionsDataManagerDelegate: class {
    func didChooseTransaction(_ transaction: Transaction)
}


class TransactionsDataManager: NSObject {
    
    weak var delegate: TransactionsDataManagerDelegate?
    private var lastTransactionsTableView: UITableView!
    private var transactions: [Transaction]
    private let kCellId = "transactionCell"
    
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
    
    func setTableView(_ view: UITableView) {
        lastTransactionsTableView = view
        lastTransactionsTableView.dataSource = self
        lastTransactionsTableView.delegate = self
        registerXib()
    }
    
    func updateTransactions(_ transactions: [Transaction]) {
        self.transactions = transactions
        
        UIView.transition(with: lastTransactionsTableView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.lastTransactionsTableView.reloadData() })
        

    }
    
    func updateEmpty(placeholderImage: UIImage, placeholderText: String) {        
        let placeholder = EmptyView(frame: lastTransactionsTableView.frame)

        placeholder.setup(image: placeholderImage)

        lastTransactionsTableView.tableFooterView = UIView()
        lastTransactionsTableView.backgroundView = placeholder
        lastTransactionsTableView.reloadData()
    }
}


// MARK: UITableViewDataSource

extension TransactionsDataManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let transaction = transactions[indexPath.row]
       let cell = lastTransactionsTableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as! TransactionTableViewCell
        cell.configureWith(transaction: transaction)
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension TransactionsDataManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransaction = transactions[indexPath.row]
        delegate?.didChooseTransaction(selectedTransaction)
    }
}


// MARK: - Private methods

extension TransactionsDataManager {
    private func registerXib() {
        let nib = UINib(nibName: "TransactionCell", bundle: nil)
        lastTransactionsTableView.register(nib, forCellReuseIdentifier: kCellId)
    }
}
