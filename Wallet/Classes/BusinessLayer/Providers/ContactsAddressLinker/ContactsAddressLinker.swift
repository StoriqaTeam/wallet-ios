//
//  ContactsAddressLinker.swift
//  Wallet
//
//  Created by Tata Gri on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ContactsAddressLinkerProtocol {
    func link(contacts: [Contact], address: [String: String])
}

class ContactsAddressLinker: ContactsAddressLinkerProtocol {
    
    private let contactsDataStoreService: ContactsDataStoreServiceProtocol
    
    init(contactsDataStoreService: ContactsDataStoreServiceProtocol) {
        self.contactsDataStoreService = contactsDataStoreService
    }
    
    func link(contacts: [Contact], address: [String: String]) {
        var linked = [Contact]()
        
        for var contact in contacts {
            let address = address[contact.id]
            contact.setCryptoAddress(address: address)
            linked.append(contact)
        }
        
        contactsDataStoreService.updateAllContacts(with: linked)
    }
    
}
