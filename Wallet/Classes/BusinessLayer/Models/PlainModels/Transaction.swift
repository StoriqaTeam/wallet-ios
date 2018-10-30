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
        self.cryptoAmount = object.cryptoAmount.decimalValue()
        self.fee = object.fee.decimalValue()
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
    
    init?(json: JSON) {
        guard let id = json["id"].string,
            let currencyStr = json["currency"].string,
            let value = json["value"].string,
            let fee = json["fee"].string,
            let statusStr = json["status"].string,
            let createdAt = json["createdAt"].double,
            let updatedAt = json["updatedAt"].double,
            let from = json["from"].array else {
                return nil
        }
        
        let blockchainId = json["blockchainTxId"].stringValue
        let to = json["to"]
        let toAccount = TransactionAccount(json: to)
        let fromAddress = from.compactMap { $0["blockchain_address"].string }
        let fromAccounts = from.compactMap { TransactionAccount(json: $0) }
        
        guard let toAddress = to["blockchain_address"].string,
            !fromAddress.isEmpty else {
                return nil
        }
        
        self.id = id
        self.currency = Currency(string: currencyStr)
        self.status = TransactionStatus(string: statusStr)
        self.blockchainId = blockchainId
        self.createdAt = Date(timeIntervalSince1970: createdAt)
        self.updatedAt = Date(timeIntervalSince1970: updatedAt)
        self.toAddress = toAddress
        self.toAccount = toAccount
        self.fromAddress = fromAddress
        self.fromAccount = fromAccounts
        self.cryptoAmount = value.decimalValue()
        self.fee = fee.decimalValue()
    }
}
