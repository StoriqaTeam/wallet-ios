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
    func update(_ user: User)
    func delete()
    func getCurrentUser() -> User
}

class UserDataStoreService: RealmStorable<User>, UserDataStoreServiceProtocol {
    func delete() {
        deleteAll()
    }
    
    func update(_ user: User) {
        var user = user
        let current = getCurrentUser()
        
        if current.id != user.id {
            deleteAll()
        } else if user.photo == nil {
            user.photo = current.photo
        }
        
        save(user)
    }
    
    func getCurrentUser() -> User {
        return find().first!
    }
    
}
