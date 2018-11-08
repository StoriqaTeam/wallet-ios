//
//  RealmRate.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable identifier_name

import Foundation
import RealmSwift

@objcMembers
class RealmRate: Object {
    
    dynamic var fromISO: String = ""
    dynamic var toISO: String = ""
    dynamic var fiatValue: String = ""
    
    dynamic var id: String = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
