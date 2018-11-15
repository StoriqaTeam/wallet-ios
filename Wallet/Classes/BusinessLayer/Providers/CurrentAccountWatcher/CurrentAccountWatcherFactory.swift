//
//  CurrentAccountWatcherFactory.swift
//  Wallet
//
//  Created by Storiqa on 09/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrentAccountWatcherFactoryProtocol {
    func create() -> CurrentAccountWatcherProtocol
}

class CurrentAccountWatcherFactory: CurrentAccountWatcherFactoryProtocol {
    
    private let accountProvider: AccountsProviderProtocol
    
    init(accountProvider: AccountsProviderProtocol) {
        self.accountProvider = accountProvider
    }
    
    func create() -> CurrentAccountWatcherProtocol {
        return CurrentAccountWatcher(accountProvider: accountProvider)
    }
}
