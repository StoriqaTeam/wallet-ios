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
    
    init(accountWatcher: CurrentAccountWatcherProtocol) {
        self.accountWatcher = accountWatcher
    }
}


// MARK: - MainTabBarInteractorInput

extension MainTabBarInteractor: MainTabBarInteractorInput {
    func getAccountWatcher() -> CurrentAccountWatcherProtocol {
        return accountWatcher
    }
}
