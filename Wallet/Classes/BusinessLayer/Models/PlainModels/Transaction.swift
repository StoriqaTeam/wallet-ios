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
    
    var smallImage: UIImage {
        switch self {
        case .btc:
            return #imageLiteral(resourceName: "currency_btc_small")
        case .eth:
            return #imageLiteral(resourceName: "currency_eth_small")
        case .stq:
            return #imageLiteral(resourceName: "currency_stq_small")
        case .fiat:
            return #imageLiteral(resourceName: "currency_fiat_small")
        }
    }
    
    var mediumImage: UIImage {
        switch self {
        case .btc:
            return #imageLiteral(resourceName: "currency_btc_medium")
        case .eth:
            return #imageLiteral(resourceName: "currency_eth_medium")
        case .stq:
            return #imageLiteral(resourceName: "currency_stq_medium")
        case .fiat:
            return #imageLiteral(resourceName: "currency_fiat_medium")
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
