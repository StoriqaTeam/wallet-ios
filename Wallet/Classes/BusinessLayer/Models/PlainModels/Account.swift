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
    let userId: Int
    let accountAddress: String
    let name: String
    let createdAt: Date
    let updatedAt: Date
}


// MARK: - RealmMappable

extension Account: RealmMappable {
    init(_ object: RealmAccount) {
        self.id = object.id
        self.balance = object.balance.decimalValue()
        self.currency = Currency.btc
        self.userId = object.userId
        self.name = object.name
        self.accountAddress = object.accountAddress
        self.currency = Currency(string: object.currency)
        self.createdAt = Date(timeIntervalSince1970: object.createdAt)
        self.updatedAt = Date(timeIntervalSince1970: object.updatedAt)
    }
    
    init?(json: JSON) {
        guard let id = json["id"].string,
            let userId = json["userId"].int,
            let currencyStr = json["currency"].string,
            let accountAddress = json["accountAddress"].string,
            let name = json["name"].string,
            let balance = json["balance"].string,
            let createdAt = json["createdAt"].double,
            let updatedAt = json["updatedAt"].double else {
                return nil
        }
        let currency = Currency(string: currencyStr)
        
        self.id = id
        self.userId = userId
        self.currency = currency
        self.accountAddress = accountAddress
        
        // FIXME: не забыть поправить в AccountTypeResolver
        
        self.balance = balance.decimalValue()
        self.name = name

        self.createdAt = Date(timeIntervalSince1970: createdAt)
        self.updatedAt = Date(timeIntervalSince1970: updatedAt)
    }
    
    func mapToRealmObject() -> RealmAccount {
        let object = RealmAccount()
        
        object.id = self.id
        object.balance = self.balance.string
        object.userId = self.userId
        object.accountAddress = self.accountAddress
        object.name = self.name
        object.currency = self.currency.ISO
        
        let createdAt = self.createdAt.timeIntervalSince1970
        object.createdAt = Double(createdAt)
        
        let updatedAt = self.updatedAt.timeIntervalSince1970
        object.updatedAt = Double(updatedAt)
        
        return object
    }
}


extension Account: Equatable {
    public static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.id == rhs.id
    }
}
