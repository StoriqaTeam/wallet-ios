//
//  Transaction.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.r
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name function_body_length

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
    let fromAddress: [String]
    let fromAccount: [TransactionAccount]
    let toAddress: String
    let toAccount: TransactionAccount?
    let fromValue: Decimal
    let fromCurrency: Currency
    let toValue: Decimal
    let toCurrency: Currency
    let fee: Decimal
    let blockchainIds: [String]
    let createdAt: Date
    let updatedAt: Date
    let status: TransactionStatus
    let fiatValue: String?
    let fiatCurrency: Currency?
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
        
        self.fromCurrency = Currency(string: object.fromCurrency)
        self.fromValue = object.fromValue.decimalValue()
        self.toCurrency = Currency(string: object.toCurrency)
        self.toValue = object.toValue.decimalValue()
        self.fee = object.fee.decimalValue()
        self.blockchainIds = object.blockchainIds.map { $0.value }
        self.createdAt = Date(timeIntervalSince1970: object.createdAt)
        self.updatedAt = Date(timeIntervalSince1970: object.updatedAt)
        self.status = TransactionStatus(string: object.status)
        self.fiatValue = object.fiatValue
        
        if let fiatCurrency = object.fiatCurrency {
            self.fiatCurrency = Currency(string: fiatCurrency)
        } else {
            self.fiatCurrency = nil
        }
    }
    
    func mapToRealmObject() -> RealmTransaction {
        let object = RealmTransaction()
        
        object.id = self.id
        object.fromAddress.append(objectsIn: self.fromAddress.map { StringObject(value: $0) })
        object.fromAccount.append(objectsIn: self.fromAccount.map { RealmTransactionAccountObject(value: $0.mapToRealmObject()) })
        object.toAddress = self.toAddress
        object.toAccount = self.toAccount?.mapToRealmObject()
        object.toValue = self.toValue.string
        object.toCurrency = self.toCurrency.ISO
        object.fromValue = self.fromValue.string
        object.fromCurrency = self.fromCurrency.ISO
        object.fee = self.fee.string
        object.blockchainIds.append(objectsIn: self.blockchainIds.map { StringObject(value: $0) })
        
        let createdAt = self.createdAt.timeIntervalSince1970
        object.createdAt = Double(createdAt)
        
        let updatedAt = self.updatedAt.timeIntervalSince1970
        object.updatedAt = Double(updatedAt)
        
        object.status = self.status.rawValue
        object.fiatValue = self.fiatValue
        object.fiatCurrency = self.fiatCurrency?.ISO
        
        return object
    }
    
    init?(json: JSON) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DateFormats.txDateString
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let id = json["id"].string,
            let toCurrencyStr = json["toCurrency"].string,
            let fromCurrencyStr = json["fromCurrency"].string,
            let toValue = json["toValue"].string,
            let fromValue = json["fromValue"].string,
            let fee = json["fee"].string,
            let statusStr = json["status"].string,
            let createdAtStr = json["createdAt"].string,
            let updatedAtStr = json["updatedAt"].string,
            let createdAt = dateFormatter.date(from: createdAtStr),
            let updatedAt = dateFormatter.date(from: updatedAtStr),
            let from = json["from"].array else {
                return nil
        }
        
        let blockchainIds = json["blockchain_tx_ids"].arrayValue
        let to = json["to"]
        let toAccount = TransactionAccount(json: to)
        let fromAddress = from.compactMap { $0["blockchain_address"].string }
        let fromAccounts = from.compactMap { TransactionAccount(json: $0) }
        
        guard let toAddress = to["blockchain_address"].string,
            !fromAddress.isEmpty else {
                return nil
        }
        
        if let fiatValue = json["fiatValue"].string,
            let fiatCurrencyStr = json["fiatCurrency"].string {
            let fiatCurrency = Currency(string: fiatCurrencyStr)
            self.fiatCurrency = fiatCurrency
            self.fiatValue = fiatValue
        } else {
            self.fiatCurrency = nil
            self.fiatValue = nil
        }
        
        self.id = id
        self.status = TransactionStatus(string: statusStr)
        self.blockchainIds = blockchainIds.compactMap { $0.string }
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.toAddress = toAddress
        self.toAccount = toAccount
        self.fromAddress = fromAddress
        self.fromAccount = fromAccounts
        self.toValue = toValue.decimalValue()
        self.fromValue = fromValue.decimalValue()
        self.toCurrency = Currency(string: toCurrencyStr)
        self.fromCurrency = Currency(string: fromCurrencyStr)
        self.fee = fee.decimalValue()
    }
}
