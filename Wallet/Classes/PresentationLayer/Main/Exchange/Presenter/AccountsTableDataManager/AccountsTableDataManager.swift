//
//  AccountsTableDataManager.swift
//  Wallet
//
//  Created by Tata Gri on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsTableDataManagerDelegate: class {
    func chooseAccount(_ index: Int)
}

class AccountsTableDataManager: NSObject {
    
    weak var delegate: AccountsTableDataManagerDelegate!
    var accounts: [Account] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var tableView: UITableView!
    private let kCellIdentifier = "AccountTableCell"
    private let cellHeight: CGFloat = 60
    private let currencyFormatter: CurrencyFormatterProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol) {
        self.currencyFormatter = currencyFormatter
    }
    
    func setTableView(_ view: UITableView) {
        tableView = view
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsetsMake(4, 0, 4, 0)
        tableView.separatorStyle = .none
        tableView.rowHeight = cellHeight
        registerXib()
    }
    
    func calculateHeight() -> CGFloat {
        return cellHeight * CGFloat(accounts.count) + tableView.contentInset.top + tableView.contentInset.bottom
    }
    
}


// MARK: - UITableViewDataSource

extension AccountsTableDataManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! AccountTableCell
        configureCell(cell: cell, account: account)
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension AccountsTableDataManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.chooseAccount(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - Private methods

extension AccountsTableDataManager {
    
    private func registerXib() {
        let nib = UINib(nibName: kCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
    }
    
    private func configureCell(cell: AccountTableCell, account: Account) {
        let image = account.currency.smallImage
        let accountName = account.accountName
        
        //TODO: decimal amount
        let amount = account.cryptoAmount.decimalValue()
        let formatted = currencyFormatter.getStringFrom(amount: amount, currency: account.currency)
        
        cell.configure(image: image, accountName: accountName, amount: formatted)
    }
    
}
