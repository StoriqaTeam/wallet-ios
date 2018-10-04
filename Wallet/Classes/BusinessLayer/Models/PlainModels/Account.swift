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
    let cryptoAddress: String
    
    var imageForType: UIImage {
        switch type {
        case .stq:
            return UIImage(named: "stqCard")!
        case .stqBlack:
            return UIImage(named: "stqBlackCard")!
        case .stqGold:
            return UIImage(named: "stqGoldCard")!
        case .btc:
            return UIImage(named: "btcCard")!
        case .eth:
            return UIImage(named: "ethCard")!
        }
    }
    
    var smallImageForType: UIImage {
        switch type {
        case .stq:
            return UIImage(named: "smallStqCard")!
        case .stqBlack:
            return UIImage(named: "smallStqBlackCard")!
        case .stqGold:
            return UIImage(named: "smallStqGoldCard")!
        case .btc:
            return UIImage(named: "smallBtcCard")!
        case .eth:
            return UIImage(named: "smallEthCard")!
        }
    }
    
    var textColorForType: UIColor {
        switch type {
        case .stqBlack,
             .stqGold:
            return .white
        case .stq,
             .eth,
             .btc:
            return .black
        }
    }
    
    var accountName: String {
        //FIXME: accountName
        switch type {
        case .stq:
            return "STQ account"
        case .stqBlack:
            return "STQ Black account"
        case .stqGold:
            return "STQ Gold account"
        case .btc:
            return "BTC account"
        case .eth:
            return "ETH account"
        }
    }
}

extension Account: Equatable {

}
