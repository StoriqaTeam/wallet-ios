//
//  FakeTransactionProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 27.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class FakeTransactionsProvider: TransactionsProviderProtocol {
    
    private let transactionMapper: TransactionMapper
    
    init(transactionMapper: TransactionMapper) {
        self.transactionMapper = transactionMapper
    }

    private let txStorage = [
        
        Transaction(id: "0",
                    currency: .btc,
                    fromAddress: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2",
                    toAddress: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy",
                    cryptoAmount: Decimal(10.05),
                    fee: Decimal(0.5),
                    timestamp: Date(timeIntervalSince1970: Double(1539165973))),

        Transaction(id: "1",
                    currency: .btc,
                    fromAddress: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy",
                    toAddress: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2",
                    cryptoAmount: Decimal(1.4555),
                    fee: Decimal(0.05),
                    timestamp: Date(timeIntervalSince1970: Double(1539121973))),
        
        Transaction(id: "2",
                    currency: .btc,
                    fromAddress: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2",
                    toAddress: "1EvSi5mhycYPmmei1JBwyMvFSgNvPkkpXm ",
                    cryptoAmount: Decimal(22.12),
                    fee: Decimal(0.2494),
                    timestamp: Date(timeIntervalSince1970: Double(153901973))),
        
        Transaction(id: "3",
                    currency: .btc,
                    fromAddress: "13pwG5PtwxD6XBXTppWhnNKFYtoNP4WQKB",
                    toAddress: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2  ",
                    cryptoAmount: Decimal(15.32),
                    fee: Decimal(0.0494),
                    timestamp: Date(timeIntervalSince1970: Double(153921973))),
        
        Transaction(id: "4",
                    currency: .eth,
                    fromAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    toAddress: "0x92699c596c2cf744749c90049db3a521bb846ef4",
                    cryptoAmount: Decimal(10.555),
                    fee: Decimal(0.00044),
                    timestamp: Date(timeIntervalSince1970: Double(153921973))),
        
        Transaction(id: "5",
                    currency: .eth,
                    fromAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    toAddress: "0x6f50c6bff08ec925232937b204b0ae23c488402a",
                    cryptoAmount: Decimal(5.35),
                    fee: Decimal(0.00033),
                    timestamp: Date(timeIntervalSince1970: Double(153925973))),
        
        Transaction(id: "6",
                    currency: .eth,
                    fromAddress: "0xb89e4b025d5afa434c0a3b70a2482f42901bea46",
                    toAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    cryptoAmount: Decimal(7.5),
                    fee: Decimal(0.00033),
                    timestamp: Date(timeIntervalSince1970: Double(153923973))),

        Transaction(id: "7",
                    currency: .stq,
                    fromAddress: "0x6f50c6bff08ec925232937b204b0ae23c488402a",
                    toAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    cryptoAmount: Decimal(10000),
                    fee: Decimal(1),
                    timestamp: Date(timeIntervalSince1970: Double(153922973))),
        
        Transaction(id: "8",
                    currency: .stq,
                    fromAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    toAddress: "0xb89e4b025d5afa434c0a3b70a2482f42901bea46",
                    cryptoAmount: Decimal(10230),
                    fee: Decimal(1),
                    timestamp: Date(timeIntervalSince1970: Double(153922973))),
        
        Transaction(id: "9",
                    currency: .stq,
                    fromAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    toAddress: "0xb89e4b025d5afa434c0a3b70a2482f42901bea46",
                    cryptoAmount: Decimal(10230),
                    fee: Decimal(12),
                    timestamp: Date(timeIntervalSince1970: Double(153922973))),
        
        Transaction(id: "10",
                    currency: .stq,
                    fromAddress: "0x6f50c6bff08ec925232937b204b0ae23c488402a",
                    toAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    cryptoAmount: Decimal(300230),
                    fee: Decimal(2),
                    timestamp: Date(timeIntervalSince1970: Double(153929973)))
    ]
    
    
    func transactionsFor(account: Account) -> [TransactionDisplayable] {
        let txsDisplayble = txStorage.map { transactionMapper.map(from: $0) }
        return fetchTransactions(transactions: txsDisplayble, currency: account.currency)
    }
}


// MARK: - Private methods

extension FakeTransactionsProvider {
    private func fetchTransactions(transactions: [TransactionDisplayable], currency: Currency) -> [TransactionDisplayable] {
        switch currency {
        case .btc:
            return transactions.filter { $0.currency == .btc }
        case .eth:
            return transactions.filter { $0.currency == .eth }
        default:
            return transactions.filter { $0.currency == .stq }
        }
    }
}
