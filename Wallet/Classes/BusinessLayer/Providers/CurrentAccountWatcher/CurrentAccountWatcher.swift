//
//  CurrentAccountWatcher.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 02/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol CurrentAccountWatcherProtocol {
    func setAccount(_ account: AccountDisplayable)
    func getAccount() -> AccountDisplayable
}


class CurrentAccountWatcher: CurrentAccountWatcherProtocol {
    
    private var currentAccount: AccountDisplayable
    
    init(accountProvider: AccountsProviderProtocol) {
        self.currentAccount = accountProvider.getAllAccounts().first!
    }
    
    func setAccount(_ account: AccountDisplayable) {
        currentAccount = account
    }
    
    func getAccount() -> AccountDisplayable {
        return currentAccount
    }
    
}
