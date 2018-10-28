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
    private var shortPollingChannelInput: ShortPollingChannel?
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol) {
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        
        accountsProvider.setObserver(self)
    }
    
    deinit {
        self.shortPollingChannelInput?.removeObserver(withId: self.objId)
        self.shortPollingChannelInput = nil
    }
    
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let id = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return id
    }()
    
    func setShortPollingChannelInput(_ channel: ShortPollingChannel) {
        self.shortPollingChannelInput = channel
        let observer = Observer<String?>(id: self.objId) { [weak self] (_) in
            self?.signalPolling()
        }
        self.shortPollingChannelInput?.addObserver(observer)
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


// MARK: - AccountsProviderDelegate

extension MyWalletInteractor: AccountsProviderDelegate {
    func accountsDidUpdate(_ accounts: [Account]) {
        output.updateAccounts(accounts: accounts)
    }
}


// MARK: - Private methods

extension MyWalletInteractor {
    
    private func signalPolling() {
        log.debug("Get polling signal")
    }
}
