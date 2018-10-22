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
    
    private let keychainProvider: KeychainProviderProtocol
    private let userStoreService: UserDataStoreServiceProtocol
    
    init(userStoreService: UserDataStoreServiceProtocol,
         keychainProvider: KeychainProviderProtocol) {
        self.userStoreService = userStoreService
        self.keychainProvider = keychainProvider
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
    
    func isPinLoginEnabled() -> Bool {
        return keychainProvider.pincode != nil
    }
    
}
