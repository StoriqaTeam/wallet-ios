//
//  MyWalletInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

class MyWalletInteractor {
    weak var output: MyWalletInteractorOutput!
    
    private let accountsProvider: AccountsProviderProtocol
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let accountsUpdater: AccountsUpdaterProtocol
    private let txnUpdater: TransactionsUpdaterProtocol
    private var accountsUpadateChannelInput: AccountsUpdateChannel?
    private var userUpadateChannelInput: UserUpdateChannel?
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         accountsUpdater: AccountsUpdaterProtocol,
         txnUpdater: TransactionsUpdaterProtocol) {
        
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        self.accountsUpdater = accountsUpdater
        self.txnUpdater = txnUpdater
    }
    
    deinit {
        self.accountsUpadateChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadateChannelInput = nil
        
        self.userUpadateChannelInput?.removeObserver(withId: self.objId)
        self.userUpadateChannelInput = nil
    }
    
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let id = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return id
    }()
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadateChannelInput = channel
    }
    
    func setUserUpdateChannelInput(_ channel: UserUpdateChannel) {
        self.userUpadateChannelInput = channel
    }
    
}


// MARK: - MyWalletInteractorInput

extension MyWalletInteractor: MyWalletInteractorInput {
    func refreshAccounts() {
        accountsUpdater.update()
        txnUpdater.update()
    }
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getAccountWatcher() -> CurrentAccountWatcherProtocol {
        return accountWatcher
    }
    
    func startObservers() {
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadateChannelInput?.addObserver(accountsObserver)
        
        let userObserver = Observer<User>(id: self.objId) { [weak self] _ in
            self?.userDidUpdate()
        }
        self.userUpadateChannelInput?.addObserver(userObserver)
    }
}


// MARK: - Private methods

extension MyWalletInteractor {
    
    private func accountsDidUpdate(_ accounts: [Account]) {
        output.updateAccounts(accounts: accounts)
    }
    
    private func userDidUpdate() {
        output.userDidUpdate()
    }
}
