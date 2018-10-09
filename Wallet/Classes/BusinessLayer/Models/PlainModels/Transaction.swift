//
//  Transaction.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.r
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum Direction {
    case receive
    case send
}

enum OpponentType {
    case contact(contact: Contact)
    case address(address: String)
}

struct Transaction {
    let id: String
    let currency: Currency
    let fromAddress: String
    let toAddress: String
    let cryptoAmount: Decimal
    let fee: Decimal
    let timestamp: Date
}


// - MARK: - RealmMappable

extension Transaction: RealmMappable {
    
    typealias RealmType = RealmTransaction
    
    init(_ object: RealmTransaction) {
        self.id = object.id
        self.fromAddress = object.fromAddress
        self.toAddress = object.toAddress
        self.currency = Currency(string: object.currency)
        self.cryptoAmount = Decimal(object.cryptoAmount)
        self.fee = Decimal(object.fee)
        
        
    }
    
    func mapToRealmObject() -> RealmTransaction {
        fatalError()
    }
    
    
    
    
}
