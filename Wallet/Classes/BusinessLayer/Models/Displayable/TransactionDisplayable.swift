//
//  TransactionDisplayable.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum Direction {
    case receive
    case send
}

enum OpponentType {
    case txAccount(account: TransactionAccount, address: String)
    case address(address: String)
}

class TransactionDisplayable {
    
    let transaction: Transaction
    let currency: Currency
    let secondAmountString: String
    let cryptoAmountString: String
    let direction: Direction
    let opponent: OpponentType
    let timestamp: String
    let feeAmountString: String
    
    init(transaction: Transaction,
         cryptoAmountString: String,
         currency: Currency,
         secondAmountString: String,
         direction: Direction,
         opponent: OpponentType,
         feeAmountString: String,
         timestamp: String) {
        
        self.transaction = transaction
        self.currency = currency
        self.cryptoAmountString = cryptoAmountString
        self.secondAmountString = secondAmountString
        self.direction = direction
        self.opponent = opponent
        self.timestamp = timestamp
        self.feeAmountString = feeAmountString
    }
    
}
