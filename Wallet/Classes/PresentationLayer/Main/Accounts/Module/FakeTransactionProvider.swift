//
//  FakeTransactionProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 27.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class FakeTransactionsProvider: TransactionsProviderProtocol {
    
    private let txStorage = [
        Transaction(currency: .btc,
                    direction: .send,
                    fiatAmount: 100,
                    cryptoAmount: 2,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .contact(contact:
                        Contact(givenName: "Satoshi",
                                familyName: "B.",
                                mobile: "123-456-789",
                                imageData: nil))),
        
        Transaction(currency: .btc,
                    direction: .send,
                    fiatAmount: 10870,
                    cryptoAmount: 2,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .address(address: "17vnx...131")),
        
        Transaction(currency: .btc,
                    direction: .send,
                    fiatAmount: 3500,
                    cryptoAmount: 0.5,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .contact(contact:
                        Contact(givenName: "Daniil",
                                familyName: "M.",
                                mobile: "123-123-123",
                                imageData: nil))),
        
        Transaction(currency: .eth,
                    direction: .send,
                    fiatAmount: 840,
                    cryptoAmount: 4,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .address(address: "0x034...2c1")),
        
        Transaction(currency: .eth,
                    direction: .receive,
                    fiatAmount: 220,
                    cryptoAmount: 1.04,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .contact(contact:
                        Contact(givenName: "Iron",
                                familyName: "M.",
                                mobile: "123-123-123",
                                imageData: nil))),
        
        Transaction(currency: .eth,
                    direction: .send,
                    fiatAmount: 420,
                    cryptoAmount: 2,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .address(address: "0x013...1f1")),

        Transaction(currency: .stq,
                    direction: .send,
                    fiatAmount: 21,
                    cryptoAmount: 210,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .address(address: "Vitaly B.")),

        Transaction(currency: .stq,
                    direction: .receive,
                    fiatAmount: 100,
                    cryptoAmount: 1000,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .address(address: "Piter P.")),

        Transaction(currency: .stq,
                    direction: .send,
                    fiatAmount: 50,
                    cryptoAmount: 500,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .address(address: "Barak O.")),

        
        Transaction(currency: .btc,
                    direction: .receive,
                    fiatAmount: 5200,
                    cryptoAmount: 0.004,
                    timestamp: Date(),
                    status: .confirmed,
                    opponent: .address(address: "mv12ef12...32"))
    ]
    
    func transactionsFor(account: Account) -> [Transaction] {
        return fetchTransactions(accountType: account.type)
    }
    
}


// MARK: - Private methods

extension FakeTransactionsProvider {
    private func fetchTransactions(accountType: AccountType) -> [Transaction] {
        switch accountType {
        case .btc:
            return txStorage.filter { $0.currency == .btc }
        case .eth:
            return txStorage.filter { $0.currency == .eth }
        default:
            return txStorage.filter { $0.currency == .stq }
            
        }
    }
}
