//
//  CurrentAccountWatcher.swift
//  Wallet
//
//  Created by Storiqa on 02/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol CurrentAccountWatcherProtocol {
    func setAccount(_ account: Account)
    func getAccount() -> Account
}


class CurrentAccountWatcher: CurrentAccountWatcherProtocol {
    
    private var currentAccount: Account
    
    init(accountProvider: AccountsProviderProtocol) {
        self.currentAccount = accountProvider.getAllAccounts().first!
    }
    
    func setAccount(_ account: Account) {
        currentAccount = account
    }
    
    func getAccount() -> Account {
        return currentAccount
    }
    
}
