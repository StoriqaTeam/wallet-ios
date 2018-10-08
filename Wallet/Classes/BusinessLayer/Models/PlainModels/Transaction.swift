//
//  Transaction.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum Direction {
    case receive
    case send
}

enum Status {
    case pending
    case confirmed
}

enum OpponentType {
    case contact(contact: Contact)
    case address(address: String)
}

struct Transaction {
    let currency: Currency
    let direction: Direction
    let fiatAmount: Decimal
    let cryptoAmount: Decimal
    let timestamp: Date
    let status: Status
    let opponent: OpponentType
}
