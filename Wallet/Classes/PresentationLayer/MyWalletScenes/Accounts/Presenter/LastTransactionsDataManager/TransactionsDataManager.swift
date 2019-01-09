//
//  TransactionsDataManager.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionsDataManagerDelegate: class {
    func didChooseTransaction(_ transaction: TransactionDisplayable)
}


class TransactionsDataManager: NSObject {
    
    weak var delegate: TransactionsDataManagerDelegate?
    private var tableView: UITableView!
    private var transactionsSections = [[TransactionDisplayable]]()
    private let kCellId = "transactionCell"
    private let isHiddenSections: Bool
    private var emptyViewPlaceholder: EmptyView?
    private var isAnimatingApperance: Bool = false
    private var animationDuration: Double {
        return Double(tableView.frame.height / tableView.estimatedRowHeight * 0.05 + 0.5)
    }
    
    init(transactions: [TransactionDisplayable], isHiddenSections: Bool) {
        self.isHiddenSections = isHiddenSections
        super.init()
        
        createSections(transactions)
    }
    
    func setTableView(_ view: UITableView) {
        tableView = view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 70
        registerXib()
    }
    
    func firstUpdateTransactions(_ transactions: [TransactionDisplayable]) {
        updateTransactions(transactions)
        
        isAnimatingApperance = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
            self?.isAnimatingApperance = false
        }
        
    }
    
    func updateTransactions(_ transactions: [TransactionDisplayable]) {
        if transactions.isEmpty {
            transactionsSections.removeAll()
            tableView.reloadData()
            updateEmpty(placeholderImage: UIImage(named: "noTxs")!, placeholderText: "")
            return
        }
        
        createSections(transactions)
        
        if let _ = emptyViewPlaceholder {
            tableView.backgroundView = nil
        }
        
        // to prevent double animation when txs update during first table appear
        
        let reloadBlock = { [weak self] in
            guard let tableView = self?.tableView else { return }
            
            UIView.transition(with: tableView,
                              duration: 0.2,
                              options: .transitionCrossDissolve,
                              animations: { tableView.reloadData() })
        }
        
        if isAnimatingApperance {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { reloadBlock() }
        } else {
            reloadBlock()
        }
    }
    
    func updateEmpty(placeholderImage: UIImage, placeholderText: String) {        
        emptyViewPlaceholder = EmptyView(frame: tableView.frame)
        emptyViewPlaceholder!.setup(image: placeholderImage)

        tableView.backgroundView = emptyViewPlaceholder
        tableView.reloadData()
    }
}


// MARK: UITableViewDataSource

extension TransactionsDataManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionsSections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isHiddenSections { return CGFloat.leastNormalMagnitude }
        if transactionsSections.isEmpty { return CGFloat.leastNormalMagnitude }
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionsSections[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mounthTransactions = transactionsSections[indexPath.section]
        let transaction = mounthTransactions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellId, for: indexPath) as! TransactionTableViewCell
        cell.configureWith(transaction: transaction)
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension TransactionsDataManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTransaction = transactionsSections[indexPath.section][indexPath.row]
        delegate?.didChooseTransaction(selectedTransaction)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard !isHiddenSections else { return nil }
        guard !transactionsSections[0].isEmpty else { return nil }
        let mounthTransactions = transactionsSections[section]
        return mounthTransactions[0].transaction.createdAt.getMonthName()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !isHiddenSections else { return nil }
        guard !transactionsSections[0].isEmpty else { return nil }
        let mounthTransactions = transactionsSections[section]
        let title = mounthTransactions[0].transaction.createdAt.getMonthName()
        return createHeaderView(with: title)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isAnimatingApperance else { return }
        
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height/2)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: Double(indexPath.row) * 0.05, options: [], animations: {
            cell.transform = CGAffineTransform.identity
            cell.alpha = 1
        }, completion: nil)
    }
}


// MARK: - Private methods

extension TransactionsDataManager {
    private func registerXib() {
        let nib = UINib(nibName: "TransactionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kCellId)
    }
    
    private func createSections(_ txs: [TransactionDisplayable]) {
        if isHiddenSections {
            self.transactionsSections = getLastTransactions(txs)
        } else {
            self.transactionsSections = sortTransactionByDate(txs)
        }
    }
    
    private func sortTransactionByDate(_ txs: [TransactionDisplayable]) -> [[TransactionDisplayable]] {
        guard !txs.isEmpty else { return [[]] }
        
        let inputArray = txs.sorted { $0.transaction.createdAt > $1.transaction.createdAt }
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
    
    private func getLastTransactions(_ txs: [TransactionDisplayable]) -> [[TransactionDisplayable]] {
        guard !txs.isEmpty else { return [[]] }
        
        let inputArray = txs.sorted { $0.transaction.createdAt > $1.transaction.createdAt }
        return [inputArray]
    }
    
    
    private func createHeaderView(with title: String) -> UIView {
        let headerWidth = UIScreen.main.bounds.width
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: 44))
        headerView.backgroundColor = Theme.Color.backgroundColor
        
        let label = UILabel(frame: CGRect(x: 20, y: 4, width: headerWidth, height: 40))
        label.text = title.uppercased()
        label.textColor = Theme.Color.Section.transactionSectionTitle
        label.font = Theme.Font.smallText
        headerView.addSubview(label)
        
        return headerView
    }
}


private extension Date {
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
}
