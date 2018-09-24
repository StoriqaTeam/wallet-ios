//
//  Transaction.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum Currency: String {
    case btc
    case eth
    case stq
    
    var ISO: String {
        switch self {
        case .btc:
            return "BTC"
        case .eth:
            return "ETH"
        case .stq:
            return "STQ"
        }
    }
}

enum Direction {
    case receive
    case send
}

enum Status {
    case pending
    case confirmed
}

enum OpponentType {
    case contact(name: String)
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
