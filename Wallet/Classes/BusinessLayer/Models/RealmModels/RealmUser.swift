//
//  RealmUser.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import RealmSwift

@objcMembers
class RealmUser: Object {
    dynamic var id: String = ""
    dynamic var email: String = ""
    dynamic var phone: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
