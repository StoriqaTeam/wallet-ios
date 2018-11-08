//
//  RealmSession.swift
//  Wallet
//
//  Created by Storiqa on 17/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmSession: Object {
    dynamic var date: String = ""
    dynamic var device: String = ""
    
    override class func primaryKey() -> String? {
        return "date"
    }
    
}
