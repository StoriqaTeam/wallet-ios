//
//  Transaction.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.r
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

enum TransactionStatus: String {
    case pending
    case done
    
    init(string: String) {
        switch string.uppercased() {
        case "DONE":
            self = .done
        default:
            self = .pending
        }
    }
}


struct Transaction {
    let id: String
    let currency: Currency
    let fromAddress: [String]
    let fromAccount: [TransactionAccount]
    let toAddress: String
    let toAccount: TransactionAccount?
    let cryptoAmount: Decimal
    let fee: Decimal
    let blockchainId: String
    let createdAt: Date
    let updatedAt: Date
    let status: TransactionStatus
}


// MARK: - RealmMappablee

extension Transaction: RealmMappable {
    
    typealias RealmType = RealmTransaction
    
    init(_ object: RealmTransaction) {
        self.id = object.id
        
        self.fromAddress = object.fromAddress.map { $0.value }
        self.fromAccount = object.fromAccount.map { TransactionAccount($0.value!) }
        
        self.toAddress = object.toAddress
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
        self.status = TransactionStatus(string: object.status)
    }
    
    func mapToRealmObject() -> RealmTransaction {
        let object = RealmTransaction()
        
        object.id = self.id
        object.fromAddress.append(objectsIn: self.fromAddress.map { StringObject(value: $0) })
        object.fromAccount.append(objectsIn: self.fromAccount.map { RealmTransactionAccountObject(value: $0.mapToRealmObject()) })
        object.toAddress = self.toAddress
        object.toAccount = self.toAccount?.mapToRealmObject()
        object.currency = self.currency.ISO
        object.cryptoAmount = self.cryptoAmount.string
        object.fee = self.fee.string
        object.blockchainId = self.blockchainId
        
        let createdAt = self.createdAt.timeIntervalSince1970
        object.createdAt = Double(createdAt)
        
        let updatedAt = self.updatedAt.timeIntervalSince1970
        object.updatedAt = Double(updatedAt)
        
        object.status = self.status.rawValue
        
        return object
    }
}
