//
//  AccountModel.swift
//  Wallet
//
//  Created by user on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum AccountType {
    case stq
    case stqBlack
    case stqGold
    case eth
    case btc
}

struct AccountModel {
    let type: AccountType
    let cryptoAmount: String
    let fiatAmount: String
    let holderName: String
    
    var imageForType: UIImage {
        switch type {
        case .stqBlack:
            return #imageLiteral(resourceName: "stqBlackCardBackground")
        default:
            //TODO: background images
            return #imageLiteral(resourceName: "ethCardBackground")
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
