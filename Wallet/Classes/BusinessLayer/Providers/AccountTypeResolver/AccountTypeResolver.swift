//
//  AccountTypeResolver.swift
//  Wallet
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum AccountType {
    case btc
    case eth
    case stq
    case stqGold
    case stqBlack
}

protocol AccountTypeResolverProtocol {
    func getType(for account: Account) -> AccountType
}

class AccountTypeResolver: AccountTypeResolverProtocol {
    
    func getType(for account: Account) -> AccountType {
        switch account.currency {
        case .btc:
            return .btc
        case .eth:
            return .eth
        case .stq where account.balance > 5000 * pow(10, 18):
            return .stqGold
        case .stq where account.balance > 1000 * pow(10, 18):
            return .stqBlack
        default:
            return .stq
        }
    }
    
}
