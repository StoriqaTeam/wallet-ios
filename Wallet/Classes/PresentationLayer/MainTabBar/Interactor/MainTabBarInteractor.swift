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
    private let ratesUpdater: RatesUpdaterProtocol
    private let app: Application
    
    private var shortPollingChannelInput: ShortPollingChannel?
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         userDataStoreService: UserDataStoreServiceProtocol,
         accountsUpdater: AccountsUpdaterProtocol,
         txsUpdater: TransactionsUpdaterProtocol,
         ratesUpdater: RatesUpdaterProtocol,
         app: Application) {
        
        self.accountWatcher = accountWatcher
        self.userDataStoreService = userDataStoreService
        self.accountsUpdater = accountsUpdater
        self.txsUpdater = txsUpdater
        self.ratesUpdater = ratesUpdater
        self.app = app
        
        update()
    }
    
    deinit {
        self.shortPollingChannelInput?.removeObserver(withId: self.objId)
        self.shortPollingChannelInput = nil
    }
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
    func setShortPollingChannelInput(_ channel: ShortPollingChannel) {
        self.shortPollingChannelInput = channel
        let observer = Observer<String?>(id: self.objId) { [weak self] (_) in
            self?.signalPolling()
        }
        self.shortPollingChannelInput?.addObserver(observer)
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


// MARK: - Private methods

extension MainTabBarInteractor {
    private func update() {
        let user = getCurrentUser()
        accountsUpdater.update(userId: user.id)
        txsUpdater.update(userId: user.id)
        ratesUpdater.update()
    }
    
    private func signalPolling() {
        log.debug("Get polling signal")
        update()
    }
}
