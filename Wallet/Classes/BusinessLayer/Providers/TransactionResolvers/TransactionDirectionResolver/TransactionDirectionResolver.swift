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
    func resolveDirection(for transaction: Transaction) -> Direction
}


class TransactionDirectionResolver: TransactionDirectionResolverProtocol {
    private let accountProvider: AccountsProviderProtocol
    
    init(accountProvider: AccountsProviderProtocol) {
        self.accountProvider = accountProvider
    }
    
    func resolveDirection(for transaction: Transaction, account: Account) -> Direction {
        let address = account.accountAddress
        let toAddress = transaction.toAddress
        
        if address == toAddress {
            return Direction.receive
        } else {
            return Direction.send
        }
    }
    
    func resolveDirection(for transaction: Transaction) -> Direction {
        let allAddresses = accountProvider.getAllAccounts().map { return $0.accountAddress }
        let toAddress = transaction.toAddress
        
        if allAddresses.contains(where: { $0 == toAddress }) {
            return Direction.receive
        } else {
            return Direction.send
        }
    }
}
