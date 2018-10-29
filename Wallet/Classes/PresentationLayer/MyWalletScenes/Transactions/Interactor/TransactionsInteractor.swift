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
    private var txnUpdateChannelInput: TxnUpadteChannel?
    
    init(account: Account,
         transactionsProvider: TransactionsProviderProtocol) {
        self.account = account
        self.transactionsProvider = transactionsProvider
    }
    
    deinit {
        self.txnUpdateChannelInput?.removeObserver(withId: self.objId)
        self.txnUpdateChannelInput = nil
    }
    
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
}


// MARK: - TransactionsInteractorInput

extension TransactionsInteractor: TransactionsInteractorInput {
    
    func getTransactions() -> [Transaction] {
        let transactions = transactionsProvider.transactionsFor(account: account)
        return transactions
    }
    
    // MARK: - Channels
    
    func startObservers() {
        let observer = Observer<[Transaction]>(id: self.objId) { [weak self] (txn) in
            self?.transactionsDidUpdate(txn)
        }
        self.txnUpdateChannelInput?.addObserver(observer)
    }
    
    func setTxnUpdateChannelInput(_ channel: TxnUpadteChannel) {
        self.txnUpdateChannelInput = channel
    }
    
}


// MARK: - Private methods

extension TransactionsInteractor {
    
    private func transactionsDidUpdate(_ trxs: [Transaction]) {
        let txs = getTransactions()
        output.updateTransactions(txs)
    }
}
