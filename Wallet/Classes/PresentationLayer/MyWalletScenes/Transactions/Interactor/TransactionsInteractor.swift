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
    private var txsUpdateChannelInput: TxsUpdateChannel?
    
    init(account: Account,
         transactionsProvider: TransactionsProviderProtocol) {
        self.account = account
        self.transactionsProvider = transactionsProvider
    }
    
    deinit {
        self.txsUpdateChannelInput?.removeObserver(withId: self.objId)
        self.txsUpdateChannelInput = nil
    }
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
    func setTxsUpdateChannelInput(_ channel: TxsUpdateChannel) {
        self.txsUpdateChannelInput = channel
    }
    
}


// MARK: - TransactionsInteractorInput

extension TransactionsInteractor: TransactionsInteractorInput {
    
    func getTransactions() -> [Transaction] {
        let transactions = transactionsProvider.transactionsFor(account: account)
        return transactions
    }
    
    func startObservers() {
        let observer = Observer<[Transaction]>(id: self.objId) { [weak self] (txs) in
            self?.transactionsDidUpdate(txs)
        }
        self.txsUpdateChannelInput?.addObserver(observer)
    }
    
}


// MARK: - Private methods

extension TransactionsInteractor {
    
    private func transactionsDidUpdate(_ txs: [Transaction]) {
        let txs = getTransactions()
        output.updateTransactions(txs)
    }
}
