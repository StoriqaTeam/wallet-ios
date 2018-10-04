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
    
    private var contactsDataManager: ContactsDataManager!
    private let deviceContactsProvider: DeviceContactsProviderProtocol
    private let sendTransactionBuilder: SendProviderBuilderProtocol
    private let sendProvider: SendTransactionProviderProtocol
    
    init(deviceContactsProvider: DeviceContactsProviderProtocol,
         sendTransactionBuilder: SendProviderBuilderProtocol) {
        
        self.deviceContactsProvider = deviceContactsProvider
        self.sendTransactionBuilder = sendTransactionBuilder
        self.sendProvider = sendTransactionBuilder.build()
    }
    
}


// MARK: - ReceiverInteractorInput

extension ReceiverInteractor: ReceiverInteractorInput {
    
    func getContact() -> [Contact] {
        let receiverName = getReceiverName(from: sendProvider.opponentType)
        let filteredContacts = deviceContactsProvider.searchContact(text: receiverName)
        guard !filteredContacts.isEmpty else { return [] }
        
        return filteredContacts[0].contacts
    }
    
    func setScannedDelegate(_ delegate: QRScannerDelegate) {
        sendTransactionBuilder.setScannedDelegate(delegate)
    }
    
    func setContact(_ contact: Contact) {
        sendTransactionBuilder.setContact(contact)
    }
    
    func getSendTransactionBuilder() -> SendProviderBuilderProtocol {
        return sendTransactionBuilder
    }
    
    func createContactsDataManager(with tableView: UITableView) {
        contactsDataManager = ContactsDataManager()
        contactsDataManager.setTableView(tableView)
        
        deviceContactsProvider.fetchContacts { [weak self] (result) in
            switch result {
            case .success(let sections):
                DispatchQueue.main.async {
                    self?.contactsDataManager.updateContacts(sections)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    //TODO: text and image in case of no access to contacts
                    self?.contactsDataManager.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                                                          placeholderText: error.localizedDescription)
                }
                log.warn(error.localizedDescription)
            }
        }
        
    }
    
    func setContactsDataManagerDelegate(_ delegate: ContactsDataManagerDelegate) {
        contactsDataManager.delegate = delegate
    }
    
    func searchContact(text: String) {
        let filteredContacts = deviceContactsProvider.searchContact(text: text)
        
        if filteredContacts.isEmpty {
            contactsDataManager.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"),
                                            placeholderText: "There is no such number in system.\nUse another way to send funds.")
        } else {
            contactsDataManager.updateContacts(filteredContacts)
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

