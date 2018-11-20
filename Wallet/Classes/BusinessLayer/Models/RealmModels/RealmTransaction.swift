//
//  RealmTransaction.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation
import RealmSwift


@objcMembers
class RealmTransaction: Object {
    dynamic var id: String = ""
    dynamic var fromAddress = List<StringObject>()
    dynamic var fromAccount = List<RealmTransactionAccountObject>()
    dynamic var toAddress: String = ""
    dynamic var toAccount: RealmTransactionAccount?
    dynamic var fromValue: String = ""
    dynamic var fromCurrency: String = ""
    dynamic var toValue: String = ""
    dynamic var toCurrency: String = ""
    dynamic var fee: String = ""
    dynamic var blockchainIds = List<StringObject>()
    dynamic var createdAt: Double = 0
    dynamic var updatedAt: Double = 0
    dynamic var status: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


@objcMembers
class StringObject: Object {
    dynamic var value = ""
    
    convenience init(value: String) {
        self.init()
        self.value = value
    }
}

@objcMembers
class RealmTransactionAccountObject: Object {
    dynamic var value: RealmTransactionAccount?
    
    convenience init(value: RealmTransactionAccount) {
        self.init()
        self.value = value
    }
}
