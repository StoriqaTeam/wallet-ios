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
    private var txsUpdateChannelInput: TxsUpdateChannel?
    private var accountsUpadteChannelInput: AccountsUpdateChannel?
    private var userUpadateChannelInput: UserUpdateChannel?
    
    init(accountLinker: AccountsLinkerProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         transactionsProvider: TransactionsProviderProtocol) {
        self.accountLinker = accountLinker
        self.accountWatcher = accountWatcher
        self.transactionsProvider = transactionsProvider
    }
    
    deinit {
        self.txsUpdateChannelInput?.removeObserver(withId: self.objId)
        self.txsUpdateChannelInput = nil
        
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
        
        self.userUpadateChannelInput?.removeObserver(withId: self.objId)
        self.userUpadateChannelInput = nil
    }
    
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
    func setTxsUpdateChannelInput(_ channel: TxsUpdateChannel) {
        self.txsUpdateChannelInput = channel
    }
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadteChannelInput = channel
    }
    
    func setUserUpdateChannelInput(_ channel: UserUpdateChannel) {
        self.userUpadateChannelInput = channel
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
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
        
        let txsObserver = Observer<[Transaction]>(id: self.objId) { [weak self] (txs) in
            self?.transactionsDidUpdate(txs)
        }
        self.txsUpdateChannelInput?.addObserver(txsObserver)
        
        let userObserver = Observer<User>(id: self.objId) { [weak self] _ in
            self?.userDidUpdate()
        }
        self.userUpadateChannelInput?.addObserver(userObserver)
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
    
    private func transactionsDidUpdate(_ txs: [Transaction]) {
        let currentAccount = accountWatcher.getAccount()
        let txs = transactions(for: currentAccount)
        output.transactionsDidChange(txs)
    }
    
    private func accountsDidUpdate(_ accounts: [Account]) {
        let account = accountWatcher.getAccount()
        let index = accounts.index { $0 == account } ?? 0
        
        setCurrentAccountWith(index: index)
        output.updateAccounts(accounts: accounts, index: index)
    }
    
    private func userDidUpdate() {
        output.userDidUpdate()
    }
}
