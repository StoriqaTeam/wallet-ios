//
//  TransactionOpponentResolver.swift
//  Wallet
//
//  Created by Storiqa on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionOpponentResolverProtocol {
    func resolveOpponent(for transaction: Transaction, account: Account) -> OpponentType
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
    
    func resolveOpponent(for transaction: Transaction, account: Account) -> OpponentType {
        let direction = transactionDirectionResolver.resolveDirection(for: transaction, account: account)
        let fromAddress = transaction.fromAddress
        let toAddress = transaction.toAddress
        
        // FIXME: как отображать для биткоина?
        
        switch direction {
        case .receive:
            if let txAccount = transaction.fromAccount.first {
                return OpponentType.txAccount(account: txAccount, address: fromAddress.first!)
            }
            return getOpponent(from: fromAddress.first!)
        case .send:
            if let txAccount = transaction.toAccount {
                return OpponentType.txAccount(account: txAccount, address: toAddress)
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
