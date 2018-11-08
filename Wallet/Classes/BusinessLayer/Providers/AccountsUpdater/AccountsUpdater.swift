//
//  AccountsUpdater.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsUpdaterProtocol {
    func update(userId: Int)
}

class AccountsUpdater: AccountsUpdaterProtocol {
    
    private let accountsNetworkProvider: AccountsNetworkProviderProtocol
    private let accountsDataStore: AccountsDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    
    private var isUpdating = false
    
    init(accountsNetworkProvider: AccountsNetworkProviderProtocol,
         accountsDataStore: AccountsDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol) {
        self.accountsNetworkProvider = accountsNetworkProvider
        self.accountsDataStore = accountsDataStore
        self.authTokenProvider = authTokenProvider
    }
    
    func update(userId: Int) {
        guard !isUpdating else {
            return
        }
        
        isUpdating = true
        
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.accountsNetworkProvider.getAccounts(
                    authToken: token,
                    userId: userId,
                    queue: .main) { [weak self] (result) in
                        switch result {
                        case .success(let accounts):
                            log.debug(accounts.map { $0.id })
                            self?.accountsDataStore.update(accounts)
                        case .failure(let error):
                            log.warn(error.localizedDescription)
                        }
                        
                        self?.isUpdating = false
                }
            case .failure(let error):
                log.warn(error.localizedDescription)
                self?.isUpdating = false
            }
        }
    }
}
