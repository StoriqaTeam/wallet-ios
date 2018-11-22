//
//  Account.swift
//  Wallet
//
//  Created by Storiqa on 05/10/2018.
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
    let erc20Approved: Bool
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
        self.erc20Approved = object.erc20Approved
    }
    
    init?(json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormats.txDateString
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let id = json["id"].string,
            let userId = json["userId"].int,
            let currencyStr = json["currency"].string,
            let accountAddress = json["accountAddress"].string,
            let name = json["name"].string,
            let balance = json["balance"].string,
            let createdAtStr = json["createdAt"].string,
            let updatedAtStr = json["updatedAt"].string,
            let createdAt = dateFormatter.date(from: createdAtStr),
            let updatedAt = dateFormatter.date(from: updatedAtStr),
            let erc20Approved = json["erc20Approved"].bool else {
                return nil
        }
        let currency = Currency(string: currencyStr)
        
        self.id = id
        self.userId = userId
        self.currency = currency
        self.accountAddress = accountAddress
        
        self.balance = balance.decimalValue()
        self.name = name

        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.erc20Approved = erc20Approved
    }
    
    func mapToRealmObject() -> RealmAccount {
        let object = RealmAccount()
        
        object.id = self.id
        object.balance = self.balance.string
        object.userId = self.userId
        object.accountAddress = self.accountAddress
        object.name = self.name
        object.currency = self.currency.ISO
        object.erc20Approved = self.erc20Approved
        
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
