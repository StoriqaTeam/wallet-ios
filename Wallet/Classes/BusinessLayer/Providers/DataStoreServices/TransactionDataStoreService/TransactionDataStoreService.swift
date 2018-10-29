//
//  TransactionDataStoreProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionDataStoreServiceProtocol: class {
    func getTransactions() -> [Transaction]
    func save(_ transactions: [Transaction])
    func observe(updateHandler: @escaping ([Transaction]) -> Void)
}

class TransactionDataStoreService: RealmStorable<Transaction>, TransactionDataStoreServiceProtocol {
    
    func getTransactions() -> [Transaction] {
        let txs = find()
        return txs
    }
    
}
