//
//  MainTabBarInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol MainTabBarInteractorInput: class {
    func getAccountWatcher() -> CurrentAccountWatcherProtocol
    func getCurrentUser() -> User
    func getApplication() -> Application
}
