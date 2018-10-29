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
    func setObserver(_ observer: AccountsProviderDelegate)
}

protocol AccountsProviderDelegate: class {
    func accountsDidUpdate(_ accounts: [Account])
}

class AccountsProvider: RealmStorable<Account>, AccountsProviderProtocol {
    private weak var observer: AccountsProviderDelegate?
    private let dataStoreService: AccountsDataStoreServiceProtocol
    
    init(dataStoreService: AccountsDataStoreServiceProtocol) {
        self.dataStoreService = dataStoreService
    }
    
    func setObserver(_ observer: AccountsProviderDelegate) {
        self.observer = observer
        
        dataStoreService.observe { [weak self] (accounts) in
            self?.observer?.accountsDidUpdate(accounts)
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
