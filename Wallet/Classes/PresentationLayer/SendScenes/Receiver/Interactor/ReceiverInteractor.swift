//
//  ReceiverInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ReceiverInteractor {
    weak var output: ReceiverInteractorOutput!
    
    private let sendTransactionBuilder: SendProviderBuilderProtocol
    private let sendProvider: SendTransactionProviderProtocol
    private let contactsProvider: ContactsProviderProtocol
    private let contactsUpdater: ContactsCacheUpdaterProtocol
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol,
         contactsProvider: ContactsProviderProtocol,
         contactsUpdater: ContactsCacheUpdaterProtocol) {
        
        self.sendTransactionBuilder = sendTransactionBuilder
        self.sendProvider = sendTransactionBuilder.build()
        self.contactsProvider = contactsProvider
        self.contactsUpdater = contactsUpdater
    }
    
}


// MARK: - ReceiverInteractorInput

extension ReceiverInteractor: ReceiverInteractorInput {
    
    func loadContacts() {
        contactsProvider.setObserver(self)
        contactsUpdater.update { [weak self] (error) in
            DispatchQueue.main.async {
                self?.output.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                                         placeholderText: error.localizedDescription)
            }
        }
    }
    
    func getContact() -> ContactDisplayable? {
        switch sendProvider.opponentType {
        case .contact(let contact):
            return contact
        default:
            return nil
        }
    }
    
    func setScannedDelegate(_ delegate: QRScannerDelegate) {
        sendTransactionBuilder.setScannedDelegate(delegate)
    }
    
    func setContact(_ contact: ContactDisplayable) {
        sendTransactionBuilder.setContact(contact)
    }
    
    func getSendTransactionBuilder() -> SendProviderBuilderProtocol {
        return sendTransactionBuilder
    }
    
    func getAmount() -> Decimal? {
        return sendProvider.amount
    }
    
    func getReceiverCurrency() -> Currency {
        return sendProvider.receiverCurrency
    }
    
    func getSelectedAccount() -> Account {
        return sendProvider.selectedAccount
    }
}

extension ReceiverInteractor: ContactsProviderDelegate {
    func contactsDidUpdate(_ contacts: [Contact]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.output.updateContacts(contacts)
        }
    }
}


// MARK: - Private methods

extension ReceiverInteractor {
    private func getReceiverName(from opponent: OpponentType) -> String {
        switch opponent {
        case .contact(let contact):
            return contact.name
        default:
            return "Receiver Name"
        }
    }
}
