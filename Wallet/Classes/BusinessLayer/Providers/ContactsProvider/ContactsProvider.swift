//
//  ContactsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


protocol ContactsProviderProtocol: class {
    /// @dev returns nil if no contact with given address
    func getContact(address: String) -> Contact?
    /// @dev returns nil if no contact with given id
    func getContact(id: String) -> Contact?
    func getAllContacts() -> [Contact]
    func setObserver(_ observer: ContactsProviderDelegate)
}

protocol ContactsProviderDelegate: class {
    func contactsDidUpdate(_ contacts: [Contact])
}


class ContactsProvider: ContactsProviderProtocol {
    private weak var observer: ContactsProviderDelegate?
    
    private let dataStoreService: ContactsDataStoreServiceProtocol
    
    init(dataStoreService: ContactsDataStoreServiceProtocol) {
        self.dataStoreService = dataStoreService
        
    }
    
    func setObserver(_ observer: ContactsProviderDelegate) {
        self.observer = observer
        
        dataStoreService.observe { [weak self] (contacts) in
            self?.observer?.contactsDidUpdate(contacts)
        }
    }
    
    func getAllContacts() -> [Contact] {
        let contacts = dataStoreService.getAllContacts()
        return contacts
    }
    
    func getContact(address: String) -> Contact? {
        let contacts = dataStoreService.getAllContacts()
        let contact = contacts.first(where: { $0.cryptoAddress == address })
        return contact
    }
    
    func getContact(id: String) -> Contact? {
        let contacts = dataStoreService.getAllContacts()
        let contact = contacts.first(where: { $0.id == id })
        return contact
    }
}
