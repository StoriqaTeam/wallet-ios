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
    private let contactsProvider: ContactsProviderProtocol
    private let sendProvider: SendProviderProtocol
    
    init(contactsProvider: ContactsProviderProtocol,
         sendProvider: SendProviderProtocol) {
        self.contactsProvider = contactsProvider
        self.sendProvider = sendProvider
    }
    
}


// MARK: - ReceiverInteractorInput

extension ReceiverInteractor: ReceiverInteractorInput {
    
    func getHeaderApperance() -> SendingHeaderData {
        return sendProvider.getSendingHeaderData()
    }
    
    func setScannedDelegate(_ delegate: QRScannerDelegate) {
        sendProvider.scanDelegate = delegate
    }
    
    func setContact(_ contact: Contact) {
        sendProvider.setContact(contact)
    }
    
    func getSendProvider() -> SendProviderProtocol {
        return sendProvider
    }
    
    func createContactsDataManager(with tableView: UITableView) {
        contactsDataManager = ContactsDataManager()
        contactsDataManager.setTableView(tableView)
        
        contactsProvider.fetchContacts { [weak self] (result) in
            switch result {
            case .success(let sections):
                DispatchQueue.main.async {
                    self?.contactsDataManager.updateContacts(sections)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    //TODO: text and image in case of no access to contacts
                    self?.contactsDataManager.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"), placeholderText: error.localizedDescription)
                }
                log.warn(error.localizedDescription)
            }
        }
        
    }
    
    func setContactsDataManagerDelegate(_ delegate: ContactsDataManagerDelegate) {
        contactsDataManager.delegate = delegate
    }
    
    func searchContact(text: String) {
        let filteredContacts = contactsProvider.searchContact(text: text)
        
        if filteredContacts.isEmpty {
            contactsDataManager.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"), placeholderText: "There is no such number in system.\nUse another way to send funds.")
        } else {
            contactsDataManager.updateContacts(filteredContacts)
        }
    }

}
