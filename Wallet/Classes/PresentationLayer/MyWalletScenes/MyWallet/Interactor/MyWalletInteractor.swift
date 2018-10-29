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
    private var accountsUpadateChannelInput: AccountsUpdateChannel?
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         accountsUpdater: AccountsUpdaterProtocol) {
        
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        self.accountsUpdater = accountsUpdater
    }
    
    deinit {
        self.accountsUpadateChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadateChannelInput = nil
    }
    
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let id = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return id
    }()
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadateChannelInput = channel
        
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadateChannelInput?.addObserver(accountsObserver)
    }
    
}


// MARK: - MyWalletInteractorInput

extension MyWalletInteractor: MyWalletInteractorInput {
    func refreshAccounts(for user: User) {
        accountsUpdater.update(userId: user.id)
    }
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getAccountWatcher() -> CurrentAccountWatcherProtocol {
        return accountWatcher
    }
}


// MARK: - Private methods

extension MyWalletInteractor {
    
    private func accountsDidUpdate(_ accounts: [Account]) {
        output.updateAccounts(accounts: accounts)
    }
}
