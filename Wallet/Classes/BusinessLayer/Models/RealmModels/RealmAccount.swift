//
//  RealmAccount.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import RealmSwift


@objcMembers
class RealmAccount: Object {
    dynamic var id: String = ""
    dynamic var balance: String = ""
    dynamic var currency: String = ""
    dynamic var userId: Int = 0
    dynamic var accountAddress: String = ""
    dynamic var name: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
