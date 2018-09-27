//
//  AccountsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class AccountsInteractor {
    
    weak var output: AccountsInteractorOutput!
    private var account: Account
    private var accountsDataManager: AccountsDataManager!
    private var transactionDataManager: TransactionsDataManager!
    private let accountLinker: AccountsLinkerProtocol
    
    init(accountLinker: AccountsLinkerProtocol,
         account: Account) {
        
        self.accountLinker = accountLinker
        self.account = account
    }
}


// MARK: - AccountsInteractorInput

extension AccountsInteractor: AccountsInteractorInput {
    func getTransactionForCurrentAccount() -> [Transaction] {
        return transactions(for: self.account)
    }
    
    func setCurrentAccountWith(index: Int) {
        let allAccounts = accountLinker.getAllAccounts()
        account = allAccounts[index]
        let txs = transactions(for: account)
        transactionDataManager.updateTransactions(txs)
        output.ISODidChange(account.type.ICO)
    }
    
    func scrollCollection() {
        let index = resolveAccountIndex(account: account)
        accountsDataManager.scrollTo(index: index)
    }
    
    func getCurrentAccount() -> Account {
        return account
    }
        
    func getInitialCurrencyISO() -> String {
        return account.type.ICO
    }
    
    func setTransactionDataManagerDelegate(_ delegate: TransactionsDataManagerDelegate) {
        transactionDataManager.delegate = delegate
    }
    
    
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate) {
        accountsDataManager.delegate = delegate
    }
    
    func createAccountsDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountLinker.getAllAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts)
        accountsManager.setCollectionView(collectionView)
        accountsDataManager = accountsManager
    }
    
    func createTransactionsDataManager(with tableView: UITableView) {
        let txs = transactions(for: account)
        let txDataManager = TransactionsDataManager(transactions: txs)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
    }
}


// MARK: - Private methods

extension AccountsInteractor {
    func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountLinker.getAllAccounts()
        return allAccounts.index{$0 == account}!
    }
    
    private func transactions(for account: Account) -> [Transaction] {
        guard let txs = accountLinker.getTransactionsFor(account: account) else { fatalError("Given account not found") }
        return txs
    }
}
