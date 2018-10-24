//
//  ProfileInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ProfileInteractor {
    weak var output: ProfileInteractorOutput!
    
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


// MARK: - ProfileInteractorInput

extension ProfileInteractor: ProfileInteractorInput {
    
    func getCurrentUser() -> User {
        return userStoreService.getCurrentUser()
    }

    func setNewPhoto(_ photo: UIImage) {
        var user = getCurrentUser()
        user.photo = photo
        
        DispatchQueue.main.async { [weak self] in
            self?.userStoreService.save(user)
        }
    }
    
    func deleteAppData() {
        userStoreService.resetAllDatabase()
        keychainProvider.deleteAll()
        defaultsProvider.isFirstLaunch = true
        defaultsProvider.isQuickLaunchShown = false
    }
}
