//
//  UserDataStoreService.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


protocol UserDataStoreServiceProtocol {
    func save(_ user: User)
    func getUserWith(id: String) -> User?
}

class FakeUserDataStoreService: UserDataStoreServiceProtocol {
    
    func save(_ user: User) { }
    
    func getUserWith(id: String) -> User? {
        let user = User(id: "0",
                        email: "email@email.com",
                        phone: "111-222-33-44",
                        firstName: "Dmitrii",
                        lastName: "Mushchinskii")
        return user
    }
    
}

class UserDataStoreService: RealmStorable<User>, UserDataStoreServiceProtocol {
    
    func getUserWith(id: String) -> User? {
        return findOne("id == '\(id)'")
    }
}
