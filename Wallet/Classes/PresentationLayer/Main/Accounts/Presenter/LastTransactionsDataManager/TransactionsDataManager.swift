//
//  TransactionsDataManager.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionsDataManagerDelegate: class {
    func didChooseTransaction(_ transaction: TransactionDisplayable)
}


class TransactionsDataManager: NSObject {
    
    weak var delegate: TransactionsDataManagerDelegate?
    private var lastTransactionsTableView: UITableView!
    private var transactions: [TransactionDisplayable]
    private let kCellId = "transactionCell"
    private let isHiddenSections: Bool
    
    init(transactions: [TransactionDisplayable], isHiddenSections: Bool) {
        self.transactions = transactions
        self.isHiddenSections = isHiddenSections
    }
    
    func setTableView(_ view: UITableView) {
        lastTransactionsTableView = view
        lastTransactionsTableView.dataSource = self
        lastTransactionsTableView.delegate = self
        registerXib()
    }
    
    func updateTransactions(_ transactions: [TransactionDisplayable]) {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        let filteredTransactions = filterTransactionByDate(transactions)
        return filteredTransactions.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isHiddenSections { return CGFloat.leastNormalMagnitude }
        return 25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredTransactions = filterTransactionByDate(transactions)
        return filteredTransactions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filteredTransactions = filterTransactionByDate(transactions)
        let mounthTransactions = filteredTransactions[indexPath.section]
        let transaction = mounthTransactions[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isHiddenSections else { return nil }
        let filteredTransactions = filterTransactionByDate(transactions)
        let mounthTransactions = filteredTransactions[section]
        return mounthTransactions[0].transaction.timestamp.getMonthName()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isHiddenSections else { return nil }
        let filteredTransactions = filterTransactionByDate(transactions)
        let mounthTransactions = filteredTransactions[section]
        let title = mounthTransactions[0].transaction.timestamp.getMonthName()
        return createHeaderView(with: title)
    }
}


// MARK: - Private methods

extension TransactionsDataManager {
    private func registerXib() {
        let nib = UINib(nibName: "TransactionCell", bundle: nil)
        lastTransactionsTableView.register(nib, forCellReuseIdentifier: kCellId)
    }
    
    private func filterTransactionByDate(_ txs: [TransactionDisplayable]) -> [[TransactionDisplayable]] {
        guard !txs.isEmpty else { return [[]] }
        
        let inputArray = txs.sorted { $0.transaction.timestamp < $1.transaction.timestamp }
        var resultArray = [[inputArray[0]]]
        
        let calendar = Calendar(identifier: .gregorian)
        for (prevTx, nextTx) in zip(inputArray, inputArray.dropFirst()) {
            if !calendar.isDate(prevTx.transaction.timestamp, equalTo: nextTx.transaction.timestamp, toGranularity: .month) {
                resultArray.append([])
            }
            
            let lastIndex = resultArray.count - 1
            resultArray[lastIndex].append(nextTx)
        }
        
        return resultArray
    }
    
    
    private func createHeaderView(with title: String) -> UIView {
        let headerWidth = UIScreen.main.bounds.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: 25))
        headerView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 20, y: 12.5, width: headerWidth, height: 15))
        label.text = title.uppercased()
        label.textColor = Theme.Text.Color.captionGrey
        label.font = Theme.Font.smallText
        headerView.addSubview(label)
        
        return headerView
    }
}


extension Date {
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
}
