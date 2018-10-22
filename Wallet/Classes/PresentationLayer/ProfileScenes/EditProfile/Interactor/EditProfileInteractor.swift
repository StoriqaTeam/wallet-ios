//
//  EditProfileInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EditProfileInteractor {
    weak var output: EditProfileInteractorOutput!
    
    private let userDataStore: UserDataStoreServiceProtocol
    private var user: User
    
    init(userDataStore: UserDataStoreServiceProtocol) {
        self.userDataStore = userDataStore
        user = userDataStore.getCurrentUser()
    }
}


// MARK: - EditProfileInteractorInput

extension EditProfileInteractor: EditProfileInteractorInput {
    
    func getCurrentUser() -> User {
        return user
    }
    
    func updateUser(firstName: String, lastName: String) {
        user.firstName = firstName
        user.lastName = lastName
        userDataStore.save(user)
    }
    
}
