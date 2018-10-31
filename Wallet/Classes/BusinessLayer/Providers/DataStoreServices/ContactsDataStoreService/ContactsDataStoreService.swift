//
//  ContactsDataStoreService.swift
//  Wallet
//
//  Created by Storiqa on 15/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import Foundation


protocol ContactsDataStoreServiceProtocol {
    func save(_ contact: Contact)
    func save(_ contacts: [Contact])
    
    func getAllContacts() -> [Contact]
    func getContactWith(id: String) -> Contact?
    
    func updateAllContacts(with contacts: [Contact])
    func batchUpdateContacts(with contacts: [Contact])
    
    func deleteContact(_ contact: Contact)
    func deleteAll()
    
    func observe(updateHandler: @escaping ([Contact]) -> Void)
}

class ContactsDataStoreService: RealmStorable<Contact>, ContactsDataStoreServiceProtocol {
    
    func getAllContacts() -> [Contact] {
        return find()
    }
    
    func getContactWith(id: String) -> Contact? {
        let contacts = find()
        return contacts.first(where: { $0.id == id })
    }
    
    func deleteContact(_ contact: Contact) {
        let id = contact.id
        delete(primaryKey: id)
    }
    
    func updateAllContacts(with contacts: [Contact]) {
        deleteAll()
        save(contacts)
    }
    
    func batchUpdateContacts(with contacts: [Contact]) {
        save(contacts)
    }
    
    func deleteAll() {
        find().forEach { delete(primaryKey: $0.id) }
    }
}
