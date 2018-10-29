//
//  AccountsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsProviderProtocol: class {
    func getAllAccounts() -> [Account]
    func getAddresses() -> [String]
    func setAccountsUpdaterChannel(_ channel: AccountsUpdateChannel)
}

class AccountsProvider: RealmStorable<Account>, AccountsProviderProtocol {
    private let dataStoreService: AccountsDataStoreServiceProtocol
    private var accountsUpadateChannelOutput: AccountsUpdateChannel?
    
    init(dataStoreService: AccountsDataStoreServiceProtocol) {
        self.dataStoreService = dataStoreService
    }
    
    func setAccountsUpdaterChannel(_ channel: AccountsUpdateChannel) {
        guard accountsUpadateChannelOutput == nil else {
            return
        }
        
        self.accountsUpadateChannelOutput = channel
        
        dataStoreService.observe { [weak self] (accounts) in
            log.debug("Accounts updated: \(accounts.map { $0.id })", "count: \(accounts.count)")
            
            self?.accountsUpadateChannelOutput?.send(accounts)
        }
    }
    
    func getAddresses() -> [String] {
        let allAccounts = getAllAccounts()
        return allAccounts.map { $0.accountAddress }
    }
    
    func getAllAccounts() -> [Account] {
        return find()
    }
}
