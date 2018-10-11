//
//  TransactionsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionsProviderProtocol: class {
    func transactionsFor(account: Account) -> [TransactionDisplayable]
}

class TransactionsProvider: TransactionsProviderProtocol {
    
    func transactionsFor(account: Account) -> [TransactionDisplayable] {
        fatalError("'transactionsFor(account: Account)' not implemented in TransactionsProvider")
    }
}
