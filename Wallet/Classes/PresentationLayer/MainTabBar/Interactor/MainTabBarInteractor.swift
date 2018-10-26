//
//  MainTabBarInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class MainTabBarInteractor {
    weak var output: MainTabBarInteractorOutput!
    
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    private let accountsUpdater: AccountsUpdaterProtocol
    private let shortPollingService: ShortPollingTimer
    private let trxsUpdater: TransactionsUpdaterProtocol
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         userDataStoreService: UserDataStoreServiceProtocol,
         accountsUpdater: AccountsUpdaterProtocol,
         trxsUpdater: TransactionsUpdaterProtocol) {
        self.accountWatcher = accountWatcher
        self.userDataStoreService = userDataStoreService
        self.accountsUpdater = accountsUpdater
        self.trxsUpdater = trxsUpdater
        
        self.shortPollingService = ShortPollingTimer(timeout: 1)
        let user = getCurrentUser()
        accountsUpdater.update(userId: user.id)
        trxsUpdater.update(userId: user.id)
    }
}


// MARK: - MainTabBarInteractorInput

extension MainTabBarInteractor: MainTabBarInteractorInput {
    func getCurrentUser() -> User {
        return userDataStoreService.getCurrentUser()
    }
    
    func getAccountWatcher() -> CurrentAccountWatcherProtocol {
        return accountWatcher
    }
}
