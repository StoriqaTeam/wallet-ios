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
    private let txsUpdater: TransactionsUpdaterProtocol
    private let app: Application
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         userDataStoreService: UserDataStoreServiceProtocol,
         accountsUpdater: AccountsUpdaterProtocol,
         txsUpdater: TransactionsUpdaterProtocol,
         app: Application) {
        self.accountWatcher = accountWatcher
        self.userDataStoreService = userDataStoreService
        self.accountsUpdater = accountsUpdater
        self.txsUpdater = txsUpdater
        self.app = app
        let user = getCurrentUser()
        accountsUpdater.update(userId: user.id)
        txsUpdater.update(userId: user.id)
    }
}


// MARK: - MainTabBarInteractorInput

extension MainTabBarInteractor: MainTabBarInteractorInput {
    func getApplication() -> Application {
        return self.app
    }
    
    func getCurrentUser() -> User {
        return userDataStoreService.getCurrentUser()
    }
    
    func getAccountWatcher() -> CurrentAccountWatcherProtocol {
        return accountWatcher
    }
}
