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

class FakeUserDataStoreService: UserDataStoreServiceProtocol {
    
    func save(_ user: User) { }
    
    func getCurrentUser() -> User {
        let user = User(id: "0",
                        email: "email@email.com",
                        phone: "111-222-33-44",
                        firstName: "Dmitrii",
                        lastName: "Mushchinskii",
                        photo: nil)
        return user
    }
    
}

class UserDataStoreService: RealmStorable<User>, UserDataStoreServiceProtocol {
    
    override func save(_ user: User) {
        DispatchQueue.main.async {
            super.save(user)
        }
    }
    
    func getCurrentUser() -> User {
        // FIXME: Save user when logged in
        
        if let saved = find().first {
            return saved
        } else {
            let user = User(id: "0",
                            email: "email@email.com",
                            phone: "111-222-33-44",
                            firstName: "Dmitrii",
                            lastName: "Mushchinskii",
                            photo: nil)
            save(user)
            return user
        }
    }
    
}
