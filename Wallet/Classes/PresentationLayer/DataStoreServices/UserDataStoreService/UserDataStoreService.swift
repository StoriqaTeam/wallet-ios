//
//  UserDataStoreService.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol UserDataStoreServiceProtocol {
    func save(_ user: User)
    func getCurrentUser() -> User
}

class UserDataStoreService: RealmStorable<User>, UserDataStoreServiceProtocol {
    
    func getCurrentUser() -> User {
        // FIXME: Save user when logged in
        
        if let saved = find().first {
            return saved
        } else {
            let user = User(id: "0",
                            email: "email@email.com",
                            phone: "",
                            firstName: "Dmitrii",
                            lastName: "Mushchinskii",
                            photo: nil)
            save(user)
            return user
        }
    }
    
}
