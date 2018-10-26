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
    private let accountLinker: AccountsLinkerProtocol
    private let transactionsProvider: TransactionsProviderProtocol
    
    init(accountLinker: AccountsLinkerProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         transactionsProvider: TransactionsProviderProtocol) {
        self.accountLinker = accountLinker
        self.accountWatcher = accountWatcher
        self.transactionsProvider = transactionsProvider
    }
}


// MARK: - AccountsInteractorInput

extension AccountsInteractor: AccountsInteractorInput {
    func getAccounts() -> [Account] {
        return accountLinker.getAllAccounts()
    }
    
    func getAccountIndex() -> Int {
        let account = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: account)
        return index
    }
    
    func getSelectedAccount() -> Account {
        let account = accountWatcher.getAccount()
        return account
    }
    
    func getAccountsCount() -> Int {
        let allAccounts = accountLinker.getAllAccounts()
        return allAccounts.count
    }
    
    func getTransactionForCurrentAccount() -> [Transaction] {
        let currentAccount = accountWatcher.getAccount()
        return transactions(for: currentAccount)
    }
    
    func setCurrentAccountWith(index: Int) {
        let currentIndex = getAccountIndex()
        guard currentIndex != index else { return }
        
        let allAccounts = accountLinker.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        let currentAccount = accountWatcher.getAccount()
        let txs = transactions(for: currentAccount)
        output.transactionsDidChange(txs)
        output.ISODidChange(currentAccount.currency.ISO)
    }
        
    func getInitialCurrencyISO() -> String {
        let currentAccount = accountWatcher.getAccount()
        return currentAccount.currency.ISO
    }
    
    func startObservers() {
        accountLinker.setObserver(self)
        transactionsProvider.setObserver(self)
    }
}


// MARK: - AccountsProviderDelegate

extension AccountsInteractor: AccountsProviderDelegate {
    func accountsDidUpdate(_ accounts: [Account]) {
        let account = accountWatcher.getAccount()
        let index = accounts.index { $0 == account } ?? 0
        
        setCurrentAccountWith(index: index)
        output.updateAccounts(accounts: accounts, index: index)
    }
}


// MARK: - TransactionsProviderDelegate

extension AccountsInteractor: TransactionsProviderDelegate {
    func transactionsDidUpdate(_ trxs: [Transaction]) {
        let currentAccount = accountWatcher.getAccount()
        let txs = transactions(for: currentAccount)
        output.transactionsDidChange(txs)
    }
}


// MARK: - Private methods

extension AccountsInteractor {
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountLinker.getAllAccounts()
        return allAccounts.index { $0 == account } ?? 0
    }
    
    private func transactions(for account: Account) -> [Transaction] {
        guard let txs = accountLinker.getTransactionsFor(account: account) else { fatalError("Given account not found") }
        return txs
    }
}
