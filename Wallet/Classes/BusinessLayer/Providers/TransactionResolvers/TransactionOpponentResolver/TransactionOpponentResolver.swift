//
//  TransactionOpponentResolver.swift
//  Wallet
//
//  Created by Storiqa on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionOpponentResolverProtocol {
    func resolveOpponent(for transaction: Transaction, account: Account) -> OpponentType
}


class TransactionOpponentResolver: TransactionOpponentResolverProtocol {
    
    private let transactionDirectionResolver: TransactionDirectionResolverProtocol
    
    init(transactionDirectionResolver: TransactionDirectionResolverProtocol) {
        self.transactionDirectionResolver = transactionDirectionResolver
    }
    
    func resolveOpponent(for transaction: Transaction, account: Account) -> OpponentType {
        let direction = transactionDirectionResolver.resolveDirection(for: transaction, account: account)
        let fromAddress = transaction.fromAddress
        let toAddress = transaction.toAddress
        
        // FIXME: как отображать для биткоина?
        
        switch direction {
        case .receive:
            if let txAccount = transaction.fromAccount.first {
                return OpponentType.txAccount(account: txAccount, address: fromAddress.first!)
            }
            return OpponentType.address(address: fromAddress.first!)
        case .send:
            if let txAccount = transaction.toAccount {
                return OpponentType.txAccount(account: txAccount, address: toAddress)
            }
            return OpponentType.address(address: toAddress)
        }
    }
}
