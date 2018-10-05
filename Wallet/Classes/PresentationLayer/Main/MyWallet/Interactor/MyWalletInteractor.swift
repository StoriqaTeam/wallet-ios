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
    
    
    init(accountsProvider: AccountsProviderProtocol, accountWatcher: CurrentAccountWatcherProtocol) {
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
    }
}


// MARK: - MyWalletInteractorInput

extension MyWalletInteractor: MyWalletInteractorInput {
    func getAccountWatcher() -> CurrentAccountWatcherProtocol {
        return accountWatcher
    }
    
    
    func accountsCount() -> Int {
        let accounts = accountsProvider.getAllAccounts()
        return accounts.count
    }
    
    func accountModel(for index: Int) -> AccountDisplayable {
        let accounts = accountsProvider.getAllAccounts()
        guard accounts.count > index else { fatalError("Not found account at given index: \(index)") }
        return accounts[index]
    }
    
}
