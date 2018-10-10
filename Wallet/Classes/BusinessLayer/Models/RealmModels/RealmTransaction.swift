//
//  RealmTransaction.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import RealmSwift


@objcMembers
class RealmTransaction: Object {
    dynamic var id: String = ""
    dynamic var fromAddress: String = ""
    dynamic var toAddress: String = ""
    dynamic var cryptoAmount: String = ""
    dynamic var currency: String = ""
    dynamic var fee: String = ""
    dynamic var timestamp: Double = 0
}


