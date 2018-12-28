//
//  AccountsProvider.swift
//  Wallet
//
//  Created by Storiqa on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsProviderProtocol: class {
    func getAllAccounts() -> [Account]
    func setAccountsUpdaterChannel(_ channel: AccountsUpdateChannel)
}

class AccountsProvider: AccountsProviderProtocol {
    private let dataStoreService: AccountsDataStoreServiceProtocol
    private let accountsSorter: AccountsSorterProtocol
    private var accountsUpadateChannelOutput: AccountsUpdateChannel?
    
    init(dataStoreService: AccountsDataStoreServiceProtocol, accountsSorter: AccountsSorterProtocol) {
        self.dataStoreService = dataStoreService
        self.accountsSorter = accountsSorter
    }
    
    func setAccountsUpdaterChannel(_ channel: AccountsUpdateChannel) {
        guard accountsUpadateChannelOutput == nil else {
            return
        }
        
        self.accountsUpadateChannelOutput = channel
        
        dataStoreService.observe { [weak self] (accounts) in
            log.debug("Accounts updated: \(accounts.map { $0.id })", "count: \(accounts.count)")
            if let sortedAccounts = self?.accountsSorter.sortAccounts(accounts, visibleCurrency: .stq) {
                self?.accountsUpadateChannelOutput?.send(sortedAccounts)
            } else {
                self?.accountsUpadateChannelOutput?.send(accounts)
            }
        }
    }
    
    func getAllAccounts() -> [Account] {
        let allAccounts = dataStoreService.getAllAccounts()
        return accountsSorter.sortAccounts(allAccounts, visibleCurrency: .stq) 
    }
}
