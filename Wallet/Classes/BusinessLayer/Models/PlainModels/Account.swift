//
//  Account.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


struct Account {
    let id: String
    let balance: Decimal
    var currency: Currency
    let userId: String
    let accountAddress: String
    let name: String
}


// MARK: - RealmMappable

extension Account: RealmMappable {
    init(_ object: RealmAccount) {
        self.id = object.id
        self.balance = Decimal(object.balance)
        self.currency = Currency.btc
        self.userId = object.userId
        self.name = object.name
        self.accountAddress = object.accountAddress
        self.currency = Currency(string: object.currency)
    }
    
    func mapToRealmObject() -> RealmAccount {
        let object = RealmAccount()
        
        object.id = self.id
        object.balance = self.balance.string
        object.userId = self.userId
        object.accountAddress = self.accountAddress
        object.name = self.name
        object.currency = self.currency.ISO
        
        return object
    }
}
