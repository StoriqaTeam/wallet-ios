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
    private var transactionsByMonths = [[TransactionDisplayable]]()
    private let kCellId = "transactionCell"
    private let isHiddenSections: Bool
    private var emptyViewPlaceholder: EmptyView?
    
    init(transactions: [TransactionDisplayable], isHiddenSections: Bool) {
        self.isHiddenSections = isHiddenSections
        super.init()
        self.transactionsByMonths = sortTransactionByDate(transactions)
    }
    
    func setTableView(_ view: UITableView) {
        lastTransactionsTableView = view
        lastTransactionsTableView.dataSource = self
        lastTransactionsTableView.delegate = self
        lastTransactionsTableView.separatorStyle = .none
        registerXib()
    }
    
    func updateTransactions(_ transactions: [TransactionDisplayable]) {
        if transactions.isEmpty {
            updateEmpty(placeholderImage: UIImage(named: "noTxs")!, placeholderText: "")
            return
        }
        
        self.transactionsByMonths = sortTransactionByDate(transactions)
        
        if let _ = emptyViewPlaceholder {
            lastTransactionsTableView.tableFooterView = nil
            lastTransactionsTableView.backgroundView = nil
            lastTransactionsTableView.tableFooterView?.removeFromSuperview()
        }
        
        UIView.transition(with: lastTransactionsTableView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { self.lastTransactionsTableView.reloadData() })

    }
    
    func updateEmpty(placeholderImage: UIImage, placeholderText: String) {        
        emptyViewPlaceholder = EmptyView(frame: lastTransactionsTableView.frame)
        emptyViewPlaceholder!.setup(image: placeholderImage)

        lastTransactionsTableView.tableFooterView = UIView()
        lastTransactionsTableView.backgroundView = emptyViewPlaceholder
        lastTransactionsTableView.reloadData()
    }
}


// MARK: UITableViewDataSource

extension TransactionsDataManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsByMonths.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isHiddenSections { return CGFloat.leastNormalMagnitude }
        if transactionsByMonths.isEmpty { return CGFloat.leastNormalMagnitude }
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsByMonths[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mounthTransactions = transactionsByMonths[indexPath.section]
        let transaction = mounthTransactions[indexPath.row]
        let cell = lastTransactionsTableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as! TransactionTableViewCell
        cell.configureWith(transaction: transaction)
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension TransactionsDataManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransaction = transactionsByMonths[indexPath.section][indexPath.row]
        delegate?.didChooseTransaction(selectedTransaction)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isHiddenSections else { return nil }
        guard !transactionsByMonths[0].isEmpty else { return nil }
        let mounthTransactions = transactionsByMonths[section]
        return mounthTransactions[0].transaction.createdAt.getMonthName()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isHiddenSections else { return nil }
        guard !transactionsByMonths[0].isEmpty else { return nil }
        let mounthTransactions = transactionsByMonths[section]
        let title = mounthTransactions[0].transaction.createdAt.getMonthName()
        return createHeaderView(with: title)
    }
}


// MARK: - Private methods

extension TransactionsDataManager {
    private func registerXib() {
        let nib = UINib(nibName: "TransactionCell", bundle: nil)
        lastTransactionsTableView.register(nib, forCellReuseIdentifier: kCellId)
    }
    
    private func sortTransactionByDate(_ txs: [TransactionDisplayable]) -> [[TransactionDisplayable]] {
        guard !txs.isEmpty else { return [[]] }
        
        let inputArray = txs.sorted { $0.transaction.createdAt < $1.transaction.createdAt }
        var resultArray = [[inputArray[0]]]
        
        let calendar = Calendar(identifier: .gregorian)
        for (prevTx, nextTx) in zip(inputArray, inputArray.dropFirst()) {
            if !calendar.isDate(prevTx.transaction.createdAt, equalTo: nextTx.transaction.createdAt, toGranularity: .month) {
                resultArray.append([])
            }
            
            let lastIndex = resultArray.count - 1
            resultArray[lastIndex].append(nextTx)
        }
        
        return resultArray
    }
    
    
    private func createHeaderView(with title: String) -> UIView {
        let headerWidth = UIScreen.main.bounds.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: 44))
        headerView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 20, y: 4, width: headerWidth, height: 40))
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
