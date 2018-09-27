//
//  AccountModel.swift
//  Wallet
//
//  Created by user on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum AccountType: String {
    case stq
    case stqBlack
    case stqGold
    case eth
    case btc
    
    var ICO: String {
        switch self {
        case .btc:
            return "BTC"
        case .eth:
            return "ETH"
        default:
            return "STQ"
        }
    }
}

struct Account {
    let type: AccountType
    let cryptoAmount: String
    let fiatAmount: String
    let holderName: String
    let currency: Currency
    
    var imageForType: UIImage {
        switch type {
        case .stqBlack, .stq:
            return UIImage(named: "blackCardSTQ")!
        case .stqGold:
            return UIImage(named: "goldCardSTQ")!
        case .btc:
            return UIImage(named: "btcCard")!
        case .eth:
            return UIImage(named: "ethCard")!
        }
    }
    
    var textColorForType: UIColor {
        switch type {
        case .stq,
             .stqBlack,
             .stqGold:
            return .white
        case .eth,
             .btc:
            return .black
        }
    }
}

extension Account: Equatable {

}
