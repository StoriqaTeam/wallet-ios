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
                    cryptoAmount: 2,
                    timestamp: Date(),
                    opponent: .contact(contact:
                        Contact(givenName: "Satoshi",
                                familyName: "B.",
                                mobile: "123-456-789",
                                imageData: nil))),
        
        Transaction(currency: .btc,
                    direction: .send,
                    cryptoAmount: 2,
                    timestamp: Date(),
                    opponent: .address(address: "17vnx...131")),
        
        Transaction(currency: .btc,
                    direction: .send,
                    cryptoAmount: 0.5,
                    timestamp: Date(),
                    opponent: .contact(contact:
                        Contact(givenName: "Daniil",
                                familyName: "M.",
                                mobile: "123-123-123",
                                imageData: nil))),
        
        Transaction(currency: .eth,
                    direction: .send,
                    cryptoAmount: 4,
                    timestamp: Date(),
                    opponent: .address(address: "0x034...2c1")),
        
        Transaction(currency: .eth,
                    direction: .receive,
                    cryptoAmount: 1.04,
                    timestamp: Date(),
                    opponent: .contact(contact:
                        Contact(givenName: "Iron",
                                familyName: "M.",
                                mobile: "123-123-123",
                                imageData: nil))),
        
        Transaction(currency: .eth,
                    direction: .send,
                    cryptoAmount: 2,
                    timestamp: Date(),
                    opponent: .address(address: "0x013...1f1")),

        Transaction(currency: .stq,
                    direction: .send,
                    cryptoAmount: 210,
                    timestamp: Date(),
                    opponent: .address(address: "Vitaly B.")),

        Transaction(currency: .stq,
                    direction: .receive,
                    cryptoAmount: 1000,
                    timestamp: Date(),
                    opponent: .address(address: "Piter P.")),

        Transaction(currency: .stq,
                    direction: .send,
                    cryptoAmount: 500,
                    timestamp: Date(),
                    opponent: .address(address: "Barak O.")),

        
        Transaction(currency: .btc,
                    direction: .receive,
                    cryptoAmount: 0.004,
                    timestamp: Date(),
                    opponent: .address(address: "mv12ef12...32"))
    ]
    
    func transactionsFor(account: Account) -> [Transaction] {
        return fetchTransactions(currency: account.currency)
    }
    
}


// MARK: - Private methods

extension FakeTransactionsProvider {
    private func fetchTransactions(currency: Currency) -> [Transaction] {
        switch currency {
        case .btc:
            return txStorage.filter { $0.currency == .btc }
        case .eth:
            return txStorage.filter { $0.currency == .eth }
        default:
            return txStorage.filter { $0.currency == .stq }
            
        }
    }
}
