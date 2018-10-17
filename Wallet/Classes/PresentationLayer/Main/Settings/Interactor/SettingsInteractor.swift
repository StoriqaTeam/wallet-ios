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
    
    init(defaults: DefaultsProviderProtocol, keychain: KeychainProviderProtocol) {
        self.defaultsProvider = defaults
        self.keychainProvider = keychain
    }
}


// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {
    func deleteAppData() {
        keychainProvider.deleteAll()
        defaultsProvider.isFirstLaunch = true
        defaultsProvider.isQuickLaunchShown = false
    }
}
