//
//  User.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

struct User {
    let id: Int
    let email: String
    var phone: String
    var firstName: String
    var lastName: String
    var photo: UIImage?
}


// MARK: - RealmMappable

extension User: RealmMappable {
    
    init(_ object: RealmUser) {
        self.id = object.id
        self.email = object.email
        self.phone = object.phone
        self.firstName = object.firstName
        self.lastName = object.lastName
        
        if let photoData = object.photo {
            let photo = UIImage(data: photoData)
            self.photo = photo
        } else {
            self.photo = nil
        }
    }
    
    init?(json: JSON) {
        
        guard let id = json["id"].int,
            let email = json["email"].string,
            let firstName = json["firstName"].string,
            let lastName = json["lastName"].string else {
            return nil
        }
        
        let phone = json["phone"].stringValue
        
        self.id = id
        self.email = email
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        
    }
    
    func mapToRealmObject() -> RealmUser {
        let object = RealmUser()
        
        object.id = self.id
        object.email = self.email
        object.phone = self.phone
        object.firstName = self.firstName
        object.lastName = self.lastName
        object.photo = photo?.data()
        
        return object
    }
    
}
