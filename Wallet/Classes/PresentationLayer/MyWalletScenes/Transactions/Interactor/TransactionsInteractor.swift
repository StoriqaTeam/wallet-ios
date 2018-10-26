//
//  TransactionsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum DirectionFilter: Int {
    case all, send, receive
}


class TransactionsInteractor {
    weak var output: TransactionsInteractorOutput!
    
    private let account: Account
    private let transactionsProvider: TransactionsProviderProtocol
    
    init(account: Account,
         transactionsProvider: TransactionsProviderProtocol) {
        self.account = account
        self.transactionsProvider = transactionsProvider
    }
}


// MARK: - TransactionsInteractorInput

extension TransactionsInteractor: TransactionsInteractorInput {
    func getTransactions() -> [Transaction] {
        let transactions = transactionsProvider.transactionsFor(account: account)
        return transactions
    }
    
    func startObservers() {
        transactionsProvider.setObserver(self)
    }
    
}


// MARK: - TransactionsProviderDelegate

extension TransactionsInteractor: TransactionsProviderDelegate {
    func transactionsDidUpdate(_ trxs: [Transaction]) {
        let txs = getTransactions()
        output.updateTransactions(txs)
    }
}
