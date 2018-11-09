//
//  CurrentAccountWatcherFactory.swift
//  Wallet
//
//  Created by Storiqa on 09/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrentAccountWatcherFactoryProtocol {
    func create() -> CurrentAccountWatcher
}

class CurrentAccountWatcherFactory: CurrentAccountWatcherFactoryProtocol {
    
    private let accountProvider: AccountsProviderProtocol
    
    init(accountProvider: AccountsProviderProtocol) {
        self.accountProvider = accountProvider
    }
    
    func create() -> CurrentAccountWatcher {
        return CurrentAccountWatcher(accountProvider: accountProvider)
    }
}
