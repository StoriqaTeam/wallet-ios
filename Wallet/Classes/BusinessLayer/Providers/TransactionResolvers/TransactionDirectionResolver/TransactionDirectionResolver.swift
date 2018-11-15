//
//  TransactionDirectionResolver.swift
//  Wallet
//
//  Created by Storiqa on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionDirectionResolverProtocol {
    func resolveDirection(for transaction: Transaction, account: Account) -> Direction
}


class TransactionDirectionResolver: TransactionDirectionResolverProtocol {
    func resolveDirection(for transaction: Transaction, account: Account) -> Direction {
        let address = account.accountAddress
        let toAddress = transaction.toAddress
        
        if address == toAddress {
            return Direction.receive
        } else {
            return Direction.send
        }
    }
}
