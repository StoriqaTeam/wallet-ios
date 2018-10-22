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
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         userDataStoreService: UserDataStoreServiceProtocol) {
        self.accountWatcher = accountWatcher
        self.userDataStoreService = userDataStoreService
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
