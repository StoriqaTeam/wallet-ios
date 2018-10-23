//
//  MyWalletInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class MyWalletInteractor {
    weak var output: MyWalletInteractorOutput!
    
    private let accountsProvider: AccountsProviderProtocol
    private let accountWatcher: CurrentAccountWatcherProtocol
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol) {
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        
        accountsProvider.setObserver(self)
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
