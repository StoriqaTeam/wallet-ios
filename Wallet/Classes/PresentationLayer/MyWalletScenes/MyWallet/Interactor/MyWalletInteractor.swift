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
    private var accountsUpadteChannelInput: AccountsUpadteChannel?
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol) {
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
    }
    
    deinit {
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
    }
    
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let id = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return id
    }()
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpadteChannel) {
        self.accountsUpadteChannelInput = channel
        
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
    }
    
}


// MARK: - MyWalletInteractorInput

extension MyWalletInteractor: MyWalletInteractorInput {
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
