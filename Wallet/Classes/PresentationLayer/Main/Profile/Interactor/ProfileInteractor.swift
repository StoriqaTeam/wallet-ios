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
    
    private let userStoreService: UserDataStoreServiceProtocol
    private var user: User
    
    init(userStoreService: UserDataStoreServiceProtocol) {
        self.userStoreService = userStoreService
        self.user = userStoreService.getCurrentUser()
    }
}


// MARK: - ProfileInteractorInput

extension ProfileInteractor: ProfileInteractorInput {
    
    func getCurrentUser() -> User {
        return user
    }

    func setNewPhoto(_ photo: UIImage) {
        user.photo = photo
        userStoreService.save(user)
    }
    
}
