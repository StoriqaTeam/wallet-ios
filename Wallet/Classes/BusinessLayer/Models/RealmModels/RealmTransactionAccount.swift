//
//  RealmTransactionAccount.swift
//  Wallet
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers
class RealmTransactionAccount: Object {
    dynamic var accountId: String = ""
    dynamic var ownerName: String = ""
    
    override class func primaryKey() -> String? {
        return "accountId"
    }
}
