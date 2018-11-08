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
    private let cryptoAddressResolver: CryptoAddressResolverProtocol
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol,
         contactsProvider: ContactsProviderProtocol,
         contactsUpdater: ContactsCacheUpdaterProtocol,
         cryptoAddressResolver: CryptoAddressResolverProtocol) {
        
        self.sendTransactionBuilder = sendTransactionBuilder
        self.sendProvider = sendTransactionBuilder.build()
        self.contactsProvider = contactsProvider
        self.contactsUpdater = contactsUpdater
        self.cryptoAddressResolver = cryptoAddressResolver
    }
    
}


// MARK: - ReceiverInteractorInput

extension ReceiverInteractor: ReceiverInteractorInput {
    
    func loadContacts() {
        
        // FIXME: disabled before release
        output.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                           placeholderText: "Contact list in not available in this app version")
            
//        contactsProvider.setObserver(self)
//        contactsUpdater.update { [weak self] (error) in
//            DispatchQueue.main.async {
//                self?.output.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
//                                         placeholderText: error.localizedDescription)
//            }
//        }
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
    
    func validateAddress(_ address: String) -> Bool {
        let receiverCurrency = sendProvider.receiverCurrency
        
        guard let addressCurrency = cryptoAddressResolver.resove(address: address) else {
            return false
        }
        
        switch addressCurrency {
        case .eth where receiverCurrency == .eth || receiverCurrency == .stq:
            sendTransactionBuilder.setScannedAddress(address)
            return true
        case .btc where receiverCurrency == .btc:
            sendTransactionBuilder.setScannedAddress(address)
            return true
        default:
            return false
        }
    }
    
}

extension ReceiverInteractor: ContactsProviderDelegate {
    func contactsDidUpdate(_ contacts: [Contact]) {
        
        // FIXME: disabled before release
        output.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                           placeholderText: "Contact list in not available yet")
            
//        DispatchQueue.main.async { [weak self] in
//            self?.output.updateContacts(contacts)
//        }
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
