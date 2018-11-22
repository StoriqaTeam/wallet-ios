//
//  RealmAccount.swift
//  Wallet
//
//  Created by Storiqa on 05/10/2018.
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
    dynamic var createdAt: Double = 0
    dynamic var updatedAt: Double = 0
    dynamic var erc20Approved: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
