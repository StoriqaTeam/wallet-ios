//
//  AccountTypeResolver.swift
//  Wallet
//
//  Created by Tata Gri on 08/10/2018.
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
        case .stq where account.balance > 5000:
            return .stqGold
        case .stq where account.balance <= 1000:
            return .stq
        default:
            return .stqBlack
        }
    }
    
}
