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

    private let trxAddrs: [TransactionAccount?] = [
        TransactionAccount(
            accountId: "1",
            ownerName: "Tata Gri"
        ),
        TransactionAccount(
            accountId: "2",
            ownerName: "Tata Gri"
        ),
        TransactionAccount(
            accountId: "3",
            ownerName: "User One"
        ),
        TransactionAccount(
            accountId: "4",
            ownerName: "User Two"
        ),
        nil, nil, nil
    ]
    
    
    private lazy var txStorage = [
        
        Transaction(id: "0",
                    currency: .btc,
                    fromAddress: "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2",
                    toAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(10.05),
                    fee: Decimal(0.5),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1535165973)),
                    updatedAt: Date(timeIntervalSince1970: Double(1535165973))),
        Transaction(id: "1",
                    currency: .btc,
                    fromAddress: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy",
                    toAddress: "0xe139b57d647344172496bbf4feb47f86181f8ea9",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(1.4555),
                    fee: Decimal(0.05),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1539145923)),
                    updatedAt: Date(timeIntervalSince1970: Double(1539145923))),
        Transaction(id: "2",
                    currency: .btc,
                    fromAddress: "0xe139b57d647344172496bbf4feb47f86181f8ea9",
                    toAddress: "1EvSi5mhycYPmmei1JBwyMvFSgNvPkkpXm ",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(22.12),
                    fee: Decimal(0.2494),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1539335923)),
                    updatedAt: Date(timeIntervalSince1970: Double(1539335923))),
        Transaction(id: "3",
                    currency: .btc,
                    fromAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    toAddress: "0xe139b57d647344172496bbf4feb47f86181f8ea9  ",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(15.32),
                    fee: Decimal(0.0494),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1539315923)),
                    updatedAt: Date(timeIntervalSince1970: Double(1539315923))),
        Transaction(id: "4",
                    currency: .eth,
                    fromAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    toAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(10.05),
                    fee: Decimal(0.5),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1537012240)),
                    updatedAt: Date(timeIntervalSince1970: Double(1537012240))),
        Transaction(id: "5",
                    currency: .eth,
                    fromAddress: "0xe139b57d647344172496bbf4feb47f86181f8ea9",
                    toAddress: "0x6f50c6bff08ec925232937b204b0ae23c488402a",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(5.35),
                    fee: Decimal(0.00033),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1537019240)),
                    updatedAt: Date(timeIntervalSince1970: Double(1537019240))),
        Transaction(id: "6",
                    currency: .eth,
                    fromAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    toAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(7.5),
                    fee: Decimal(0.00033),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1537002240)),
                    updatedAt: Date(timeIntervalSince1970: Double(1537002240))),
        Transaction(id: "7",
                    currency: .stq,
                    fromAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    toAddress: "0xe139b57d647344172496bbf4feb47f86181f8ea9",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(10000),
                    fee: Decimal(1),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1539165923)),
                    updatedAt: Date(timeIntervalSince1970: Double(1539165923))),
        Transaction(id: "8",
                    currency: .stq,
                    fromAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    toAddress: "0xb89e4b025d5afa434c0a3b70a2482f42901bea46",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(10230),
                    fee: Decimal(1),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1539375333)),
                    updatedAt: Date(timeIntervalSince1970: Double(1539375333))),
        Transaction(id: "9",
                    currency: .stq,
                    fromAddress: "0xe139b57d647344172496bbf4feb47f86181f8ea9",
                    toAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(10230),
                    fee: Decimal(12),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1539369323)),
                    updatedAt: Date(timeIntervalSince1970: Double(1539369323))),
        Transaction(id: "10",
                    currency: .stq,
                    fromAddress: "0x1f2a4b1936a19a222410bd32f411cacacac7a027",
                    toAddress: "0x246b611aeb2302b32885d8d2a85ec503313c1a66",
                    fromAccount: trxAddrs.randomElement()!,
                    toAccount: trxAddrs.randomElement()!,
                    cryptoAmount: Decimal(300230),
                    fee: Decimal(2),
                    blockchainId: "",
                    createdAt: Date(timeIntervalSince1970: Double(1537012240)),
                    updatedAt: Date(timeIntervalSince1970: Double(1537012240)))
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
