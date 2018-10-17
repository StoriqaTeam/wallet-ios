//
//  Transaction.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.r
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


struct Transaction {
    let id: String
    let currency: Currency
    let fromAddress: String
    let toAddress: String
    let cryptoAmount: Decimal
    let fee: Decimal
    let timestamp: Date
}


// MARK: - RealmMappablee

extension Transaction: RealmMappable {
    
    typealias RealmType = RealmTransaction
    
    init(_ object: RealmTransaction) {
        self.id = object.id
        self.fromAddress = object.fromAddress
        self.toAddress = object.toAddress
        self.currency = Currency(string: object.currency)
        self.cryptoAmount = Decimal(object.cryptoAmount)
        self.fee = Decimal(object.fee)
        self.timestamp = Date(timeIntervalSince1970: object.timestamp)
    }
    
    func mapToRealmObject() -> RealmTransaction {
        let object = RealmTransaction()
        
        object.id = self.id
        object.fromAddress = self.fromAddress
        object.toAddress = self.toAddress
        object.currency = self.currency.ISO
        object.cryptoAmount = self.cryptoAmount.string
        object.fee = self.fee.string
        let timestamp = self.timestamp.timeIntervalSince1970
        object.timestamp = Double(timestamp)
        
        return object
    }
}
