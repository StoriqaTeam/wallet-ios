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
    private let contactsMapper: ContactsMapper
    
    init(contactsProvider: ContactsProviderProtocol,
         transactionDirectionResolver: TransactionDirectionResolverProtocol,
         contactsMapper: ContactsMapper) {
        self.contactsProvider = contactsProvider
        self.transactionDirectionResolver = transactionDirectionResolver
        self.contactsMapper = contactsMapper
    }
    
    func resolveOpponent(for transaction: Transaction) -> OpponentType {
        let direction = transactionDirectionResolver.resolveDirection(for: transaction)
        let fromAddress = transaction.fromAddress
        let toAddress = transaction.toAddress
        
        // FIXME: как отображать для биткоина?
        
        switch direction {
        case .receive:
            if let trxAccount = transaction.fromAccount.first {
                return OpponentType.trxAccount(account: trxAccount, address: fromAddress.first!)
            }
            return getOpponent(from: fromAddress.first!)
        case .send:
            if let trxAccount = transaction.toAccount {
                return OpponentType.trxAccount(account: trxAccount, address: toAddress)
            }
            return getOpponent(from: toAddress)
        }
    }
}


// MARK: - Private methods

extension TransactionOpponentResolver {
    private func getOpponent(from address: String) -> OpponentType {
        guard let contact = contactsProvider.getContact(address: address) else {
            return OpponentType.address(address: address)
        }
        
        let displayable = contactsMapper.map(from: contact)
        return OpponentType.contact(contact: displayable)
    }
}
