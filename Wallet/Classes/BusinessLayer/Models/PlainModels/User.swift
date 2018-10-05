//
//  User.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct User {
    let id: String
    let email: String
    let phone: String
    let firstName: String
    let lastName: String
}


// MARK: - RealmMappable

extension User: RealmMappable {
    
    init(_ object: RealmUser) {
        self.id = object.id
        self.email = object.email
        self.phone = object.phone
        self.firstName = object.firstName
        self.lastName = object.lastName
    }
    
    func mapToRealmObject() -> RealmUser {
        let object = RealmUser()
        
        object.id = self.id
        object.email = self.email
        object.phone = self.phone
        object.firstName = self.firstName
        object.lastName = self.lastName
        
        return object
    }
    
}
