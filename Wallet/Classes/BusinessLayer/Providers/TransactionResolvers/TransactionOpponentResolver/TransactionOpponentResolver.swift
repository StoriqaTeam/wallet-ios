//
//  TransactionOpponentResolver.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionOpponentResolverProtocol {
    func resolveOpponent(for transaction: Transaction) -> OpponentType
}


class TransactionOpponentResolver: TransactionOpponentResolverProtocol {
    
    private let contactsProvider: ContactsProviderProtocol
    private let transactionDirectionResolver: TransactionDirectionResolverProtocol
    
    init(contactsProvider: ContactsProviderProtocol, transactionDirectionResolver: TransactionDirectionResolverProtocol) {
        self.contactsProvider = contactsProvider
        self.transactionDirectionResolver = transactionDirectionResolver
    }
    
    func resolveOpponent(for transaction: Transaction) -> OpponentType {
        let direction = transactionDirectionResolver.resolveDirection(for: transaction)
        let fromAddress = transaction.fromAddress
        let toAddress = transaction.toAddress
        
        switch direction {
        case .receive:
            guard let contact = contactsProvider.getContact(address: fromAddress) else {
                return OpponentType.address(address: fromAddress)
            }
            
            return OpponentType.contact(contact: contact)
        case .send
        }
    }
}


// MARK: - Private methods

extension TransactionOpponentResolver {
    private func
}
