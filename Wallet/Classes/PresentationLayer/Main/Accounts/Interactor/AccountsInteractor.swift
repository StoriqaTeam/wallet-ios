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
    private var accountWatcher: CurrentAccountWatcherProtocol
    private var accountsDataManager: AccountsDataManager!
    private var transactionDataManager: TransactionsDataManager!
    private let accountLinker: AccountsLinkerProtocol
    
    init(accountLinker: AccountsLinkerProtocol,
         accountWatcher: CurrentAccountWatcherProtocol) {
        
        self.accountLinker = accountLinker
        self.accountWatcher = accountWatcher
    }
}


// MARK: - AccountsInteractorInput

extension AccountsInteractor: AccountsInteractorInput {
    func getAccountsCount() -> Int {
        let allAccounts = accountLinker.getAllAccounts()
        return allAccounts.count
    }
    
    func getTransactionForCurrentAccount() -> [Transaction] {
        let currentAccount = accountWatcher.getAccount()
        return transactions(for: currentAccount)
    }
    
    func setCurrentAccountWith(index: Int) {
        let allAccounts = accountLinker.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        let currentAccount = accountWatcher.getAccount()
        let txs = transactions(for: currentAccount)
        transactionDataManager.updateTransactions(txs)
        output.ISODidChange(currentAccount.type.ICO)
    }
    
    func scrollCollection() {
        let currentAccount = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: currentAccount)
        accountsDataManager.scrollTo(index: index)
    }
    
    func getCurrentAccount() -> AccountDisplayable {
        return accountWatcher.getAccount()
    }
        
    func getInitialCurrencyISO() -> String {
        let currentAccount = accountWatcher.getAccount()
        return currentAccount.type.ICO
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
        let currentAccount = accountWatcher.getAccount()
        let txs = transactions(for: currentAccount)
        let txDataManager = TransactionsDataManager(transactions: txs)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
    }
}


// MARK: - Private methods

extension AccountsInteractor {
    private func resolveAccountIndex(account: AccountDisplayable) -> Int {
        let allAccounts = accountLinker.getAllAccounts()
        return allAccounts.index{$0 == account}!
    }
    
    private func transactions(for account: AccountDisplayable) -> [Transaction] {
        guard let txs = accountLinker.getTransactionsFor(account: account) else { fatalError("Given account not found") }
        return txs
    }
}
