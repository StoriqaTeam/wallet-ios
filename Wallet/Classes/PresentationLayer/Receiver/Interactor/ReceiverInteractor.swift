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
    
    private let deviceContactsFetcher: DeviceContactsFetcherProtocol
    private let contactsSorter: ContactsSorterProtocol
    private let contactsMapper: ContactsMapper
    private let sendTransactionBuilder: SendProviderBuilderProtocol
    private let sendProvider: SendTransactionProviderProtocol
    
    private var contacts: [ContactDisplayable] = []
    
    init(deviceContactsFetcher: DeviceContactsFetcherProtocol,
         sendTransactionBuilder: SendProviderBuilderProtocol,
         contactsSorter: ContactsSorterProtocol,
         contactsMapper: ContactsMapper) {
        
        self.deviceContactsFetcher = deviceContactsFetcher
        self.sendTransactionBuilder = sendTransactionBuilder
        self.sendProvider = sendTransactionBuilder.build()
        self.contactsSorter = contactsSorter
        self.contactsMapper = contactsMapper
    }
    
}


// MARK: - ReceiverInteractorInput

extension ReceiverInteractor: ReceiverInteractorInput {
    
    func fetchContacts() {
        deviceContactsFetcher.fetchContacts { [weak self] (result) in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let contacts):
                    let displayable = contacts.map { strongSelf.contactsMapper.map(from: $0) }
                    strongSelf.contacts = displayable
                    
                    let sorted = strongSelf.contactsSorter.sort(contacts: displayable)
                    strongSelf.output.updateContacts(sorted)
                case .failure(let error):
                    //TODO: text and image in case of no access to contacts
                    strongSelf.output.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                                             placeholderText: error.localizedDescription)
                    
                    log.warn(error.localizedDescription)
                }
            }
        }
    }
    
    func getContact() -> ContactDisplayable? {
        let receiverName = getReceiverName(from: sendProvider.opponentType)
        let filteredContacts = contactsSorter.searchContact(text: receiverName, contacts: contacts)

        return filteredContacts.first?.contacts.first
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
    
    func searchContact(text: String) {
        let filteredContacts = contactsSorter.searchContact(text: text, contacts: contacts)

        if filteredContacts.isEmpty {
            output.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                               placeholderText: "There is no such number in system.\nUse another way to send funds.")
        } else {
            output.updateContacts(filteredContacts)
        }
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
