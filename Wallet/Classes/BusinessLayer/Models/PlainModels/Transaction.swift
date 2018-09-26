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
    case fiat
    
    var ISO: String {
        switch self {
        case .btc:
            return "BTC"
        case .eth:
            return "ETH"
        case .stq:
            return "STQ"
        case .fiat:
            return "$"
        }
    }
    
    var image: UIImage {
        switch self {
        case .btc:
            //FIXME: replace btc image
            return #imageLiteral(resourceName: "currency_btc")
        case .eth:
            return #imageLiteral(resourceName: "currency_eth")
        case .stq:
            return #imageLiteral(resourceName: "currency_stq")
        case .fiat:
            return #imageLiteral(resourceName: "currency_fiat")
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
