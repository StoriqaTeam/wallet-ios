//
//  AccountsUpdater.swift
//  Wallet
//
//  Created by Tata Gri on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsUpdaterProtocol {
    func update(userId: Int)
}

class AccountsUpdater: AccountsUpdaterProtocol {
    
    private let accountsNetworkProvider: AccountsNetworkProviderProtocol
    private let accountsDataStore: AccountsDataStoreProtocol
    
    init(accountsNetworkProvider: AccountsNetworkProviderProtocol,
         accountsDataStore: AccountsDataStoreProtocol) {
        self.accountsNetworkProvider = accountsNetworkProvider
        self.accountsDataStore = accountsDataStore
    }
    
    func update(userId: Int) {
        
        // FIXME: auth token provider
        guard let authToken = DefaultsProvider().authToken else {
            return
        }
        
        accountsNetworkProvider.getAccounts(
            authToken: authToken,
            userId: userId,
            queue: .main) { [weak self] (result) in
                switch result {
                case .success(let accounts):
                    log.debug(accounts.map { $0.id })
                    self?.accountsDataStore.update(accounts)
                    
                case .failure(let error):
                    log.warn(error.localizedDescription)
                }
        }
    }
}
