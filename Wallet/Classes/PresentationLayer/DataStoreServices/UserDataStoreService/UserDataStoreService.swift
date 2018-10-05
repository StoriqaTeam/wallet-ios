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


class UserDataStoreService: RealmStorable<User>, UserDataStoreServiceProtocol {
    
    func getUserWith(id: String) -> User? {
        return findOne("id == '\(id)'")
    }
}
