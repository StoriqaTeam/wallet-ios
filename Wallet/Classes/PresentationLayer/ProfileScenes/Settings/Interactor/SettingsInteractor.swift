//
//  SettingsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SettingsInteractor {
    weak var output: SettingsInteractorOutput!
    
    private let defaultsProvider: DefaultsProviderProtocol
    private let keychainProvider: KeychainProviderProtocol
    private let sessionsDataStore: SessionsDataStoreServiceProtocol
    
    init(defaults: DefaultsProviderProtocol,
         keychain: KeychainProviderProtocol,
         sessionsDataStore: SessionsDataStoreServiceProtocol) {
        
        self.defaultsProvider = defaults
        self.keychainProvider = keychain
        self.sessionsDataStore = sessionsDataStore
    }
}


// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {
    
    func deleteAppData() {
        keychainProvider.deleteAll()
        defaultsProvider.isFirstLaunch = true
        defaultsProvider.isQuickLaunchShown = false
    }
    
    func getSessionsCount() -> Int {
        let sessions = sessionsDataStore.getAllSessions()
        return sessions.count
    }
}
