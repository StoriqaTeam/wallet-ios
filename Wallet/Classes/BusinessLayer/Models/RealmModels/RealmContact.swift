//
//  RealmContact.swift
//  Wallet
//
//  Created by Tata Gri on 15/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import RealmSwift


@objcMembers
class RealmContact: Object {
    
    // Phone or email
    dynamic var id: String = ""
    dynamic var givenName: String = ""
    dynamic var familyName: String = ""
    dynamic var cryptoAddress: String?
    dynamic var image: Data?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
