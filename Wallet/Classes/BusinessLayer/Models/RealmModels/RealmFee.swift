//
//  RealmFee.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import RealmSwift

@objcMembers
class RealmFee: Object {
    dynamic var id: String = ""
    dynamic var fromCurrency: String = ""
    dynamic var toCurrency: String = ""
    dynamic var fees = List<RealmFeeAndWait>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
