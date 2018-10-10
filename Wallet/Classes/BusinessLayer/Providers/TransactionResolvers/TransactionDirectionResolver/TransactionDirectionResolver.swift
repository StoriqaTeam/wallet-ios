//
//  TransactionDirectionResolver.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 10/10/2018.
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
        let ethAddress = accountsProvider.getEthereumAddress()
        let btcAddress = accountsProvider.getBitcoinAddress()
        let allBlockchainAddresses = [ethAddress, btcAddress]
        let toAddress = transaction.toAddress
        
        if allBlockchainAddresses.contains(where: { $0 == toAddress }) { return Direction.receive }
        return Direction.send
    }
}
