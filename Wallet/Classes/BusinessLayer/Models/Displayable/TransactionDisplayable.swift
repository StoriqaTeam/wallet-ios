//
//  TransactionDisplayable.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionDisplayable {
    
    let transaction: Transaction
    let currency: Currency
    let fiatAmountString: String
    let cryptoAmountString: String
    let direction: Direction
    let opponent: OpponentType
    let timestamp: String
    let feeAmountString: String
    
    init(transaction: Transaction,
         cryptoAmountString: String,
         fiatAmountString: String,
         direction: Direction,
         opponent: OpponentType,
         feeAmountString: String) {
        
        self.transaction = transaction
        self.currency = transaction.currency
        self.cryptoAmountString = cryptoAmountString
        self.fiatAmountString = fiatAmountString
        self.direction = direction
        self.opponent = opponent
        self.timestamp = "\(transaction.timestamp.timeIntervalSince1970)"
        self.feeAmountString = feeAmountString
    }
    
}
