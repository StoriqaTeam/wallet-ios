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
    private let userStoreService: UserDataStoreServiceProtocol
    
    init(defaults: DefaultsProviderProtocol,
         keychain: KeychainProviderProtocol,
         userStoreService: UserDataStoreServiceProtocol) {
        self.defaultsProvider = defaults
        self.keychainProvider = keychain
        self.userStoreService = userStoreService
    }
}


// MARK: - SettingsInteractorInput

extension SettingsInteractor: SettingsInteractorInput {
    func deleteAppData() {
        userStoreService.resetAllDatabase()
        keychainProvider.deleteAll()
        defaultsProvider.clear()
    }
    
    func userHasPhone() -> Bool {
        let user = userStoreService.getCurrentUser()
        let hasPhone = !user.phone.isEmpty
        return hasPhone
    }
    
    func userLoginedWithSocialProvider() -> Bool {
        let isSocial = keychainProvider.socialAuthToken
        return isSocial != nil
    }
}
