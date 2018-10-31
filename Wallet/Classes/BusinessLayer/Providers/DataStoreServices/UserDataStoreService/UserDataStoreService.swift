//
//  UserDataStoreService.swift
//  Wallet
//
//  Created by Storiqa on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol UserDataStoreServiceProtocol {
    func save(_ user: User)
    func update(_ user: User)
    func delete()
    func getCurrentUser() -> User
    func resetAllDatabase()
}

class UserDataStoreService: RealmStorable<User>, UserDataStoreServiceProtocol {
    func delete() {
        find().forEach { delete(primaryKey: $0.id) }
    }
    
    func update(_ user: User) {
        var user = user
        let current = find().first
        
        if let current = current,
            current.id != user.id {
            delete()
        } else if user.photo == nil {
            user.photo = current?.photo
        }
        
        save(user)
    }
    
    func getCurrentUser() -> User {
        return find().first!
    }
    
}
