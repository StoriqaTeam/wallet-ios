//
//  RealmRate.swift
//  Wallet
//
//  Created by Даниил Мирошниченко on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmRate: Object {
    
    dynamic var cryptoISO: String = ""
    dynamic var toFiatISO: String = ""
    dynamic var fiatValue: String = ""
    
    dynamic var id: String = ""
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
