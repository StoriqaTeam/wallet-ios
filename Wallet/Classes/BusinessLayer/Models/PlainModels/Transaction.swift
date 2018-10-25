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
    let fromAccount: TransactionAccount?
    let toAccount: TransactionAccount?
    let cryptoAmount: Decimal
    let fee: Decimal
    let blockchainId: String
    let createdAt: Date
    let updatedAt: Date
}


// MARK: - RealmMappablee

extension Transaction: RealmMappable {
    
    typealias RealmType = RealmTransaction
    
    init(_ object: RealmTransaction) {
        self.id = object.id
        self.fromAddress = object.fromAddress
        self.toAddress = object.toAddress
        
        if let fromAccount = object.fromAccount {
            self.fromAccount = TransactionAccount(fromAccount)
        } else {
            self.fromAccount = nil
        }
        
        if let toAccount = object.toAccount {
            self.toAccount = TransactionAccount(toAccount)
        } else {
            self.toAccount = nil
        }
        
        self.currency = Currency(string: object.currency)
        self.cryptoAmount = Decimal(object.cryptoAmount)
        self.fee = Decimal(object.fee)
        self.blockchainId = object.blockchainId
        self.createdAt = Date(timeIntervalSince1970: object.createdAt)
        self.updatedAt = Date(timeIntervalSince1970: object.updatedAt)
    }
    
    func mapToRealmObject() -> RealmTransaction {
        let object = RealmTransaction()
        
        object.id = self.id
        object.fromAddress = self.fromAddress
        object.toAddress = self.toAddress
        object.fromAccount = self.fromAccount?.mapToRealmObject()
        object.toAccount = self.toAccount?.mapToRealmObject()
        object.currency = self.currency.ISO
        object.cryptoAmount = self.cryptoAmount.string
        object.fee = self.fee.string
        object.blockchainId = self.blockchainId
        
        let createdAt = self.createdAt.timeIntervalSince1970
        object.createdAt = Double(createdAt)
        
        let updatedAt = self.updatedAt.timeIntervalSince1970
        object.updatedAt = Double(updatedAt)
        
        return object
    }
}
