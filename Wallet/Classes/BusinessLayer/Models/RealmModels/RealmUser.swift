//
//  RealmUser.swift
//  Wallet
//
//  Created by Storiqa on 04/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import RealmSwift

@objcMembers
class RealmUser: Object {
    dynamic var id: Int = 0
    dynamic var email: String = ""
    dynamic var phone: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var photo: Data?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
