//
//  TransactionDirectionResolver.swift
//  Wallet
//
//  Created by Storiqa on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionDirectionResolverProtocol {
    func resolveDirection(for transaction: Transaction) -> Direction
}


class TransactionDirectionResolver: TransactionDirectionResolverProtocol {
    
    private let accountsProvider: AccountsProviderProtocol
    
    init(accountsProvider: AccountsProviderProtocol) {
        self.accountsProvider = accountsProvider
    }
    
    func resolveDirection(for transaction: Transaction) -> Direction {
        let addresses = accountsProvider.getAddresses()
        let toAddress = transaction.toAddress
        
        if addresses.contains(where: { $0 == toAddress }) {
            return Direction.receive
        } else {
            return Direction.send
        }
    }
}
