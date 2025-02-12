//
//  WalletTests.swift
//  WalletTests
//
//  Created by Storiqa on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import XCTest
@testable import Wallet

class ContactsDataStoreTests: XCTestCase {
    
    // Providers
    private var contactsDataStore: ContactsDataStoreServiceProtocol!
    private var fakeObserver: FakeObserver!
    
    // Given
    private let contact_1 = Contact(id: "1",
                                    givenName: "Name_1",
                                    familyName: "Family_1",
                                    cryptoAddress: nil,
                                    imageData: nil)
    
    private let contact_2 = Contact(id: "2",
                                    givenName: "Name_2",
                                    familyName: "Family_1",
                                    cryptoAddress: nil,
                                    imageData: nil)
    private let contact_3 = Contact(id: "3",
                                    givenName: "Name_3",
                                    familyName: "Family_3",
                                    cryptoAddress: nil,
                                    imageData: nil)
    
    
    private let updatedContact_1 = Contact(id: "1",
                                           givenName: "updated_1",
                                           familyName: "Family_1",
                                           cryptoAddress: "crypto_address_1",
                                           imageData: nil)
    private let updatedContact_2 = Contact(id: "2",
                                           givenName: "updated_2",
                                           familyName: "Family_1",
                                           cryptoAddress: "crypto_address_2",
                                           imageData: nil)
    private let updatedContact_3 = Contact(id: "3",
                                           givenName: "updated_3",
                                           familyName: "Family_1",
                                           cryptoAddress: "crypto_address_3",
                                           imageData: nil)
    
    
    override func setUp() {
        let realmPath = NSTemporaryDirectory().appending("ContactsDataStoreTests_realm")
        // Delete previous Realm file
        if FileManager.default.fileExists(atPath: realmPath) {
            try! FileManager.default.removeItem(atPath: realmPath)
        }
        
        contactsDataStore = ContactsDataStoreService(forTests: URL(string: realmPath)!)
        contactsDataStore.deleteAll()
        
        fakeObserver = FakeObserver(contactsDataStore: contactsDataStore)
        fakeObserver.startObserve()
    }

    override func tearDown() {
        removeTestContacts()
        checkRemoving()
    }
    
    
    func testContactCreation() {
        contactsDataStore.save(contact_1)
        XCTAssertEqual(contactsDataStore.getAllContacts().count, 1)
        removeTestContacts()
    }
    
    func testSingleContactReplacing() {
        contactsDataStore.save(contact_1)
        let oldContact = contactsDataStore.getContactWith(id: contact_1.id)
        XCTAssertEqual(contactsDataStore.getAllContacts().count, 1)
        XCTAssert(oldContact!.cryptoAddress == nil)
        
        let updatedContact = Contact(id: contact_1.id,
                                     givenName: "NewName",
                                     familyName: "Family_1",
                                     cryptoAddress: "crypto_address",
                                     imageData: nil)
        contactsDataStore.save(updatedContact)
        let newContact = contactsDataStore.getContactWith(id: contact_1.id)
        XCTAssertEqual(contactsDataStore.getAllContacts().count, 1)
        XCTAssert(newContact!.cryptoAddress == "crypto_address")
        removeTestContacts()
    }
    
    
    func testUpdateAllContacts() {
        contactsDataStore.save(contact_1)
        contactsDataStore.save(contact_2)
        XCTAssertEqual(contactsDataStore.getAllContacts().count, 2)
        
        contactsDataStore.updateAllContacts(with: [contact_1, contact_2, contact_3])
        XCTAssertEqual(contactsDataStore.getAllContacts().count, 3)
        removeTestContacts()
    }
    
    
    func testBatchUpdateContacts() {
        contactsDataStore.updateAllContacts(with: [contact_1, contact_2, contact_3])
        XCTAssertEqual(contactsDataStore.getAllContacts().count, 3)
        
        let batchUpdate = [updatedContact_1, updatedContact_2, updatedContact_3]
        contactsDataStore.batchUpdateContacts(with: batchUpdate)
        XCTAssertEqual(contactsDataStore.getAllContacts().count, 3)
        
        let updatedContacts = contactsDataStore.getAllContacts()
        for contact in updatedContacts where contact.cryptoAddress == nil {
            XCTFail("Fail to batch update contacts")
        }
        
        removeTestContacts()
    }
}


// MARK: Private methods

extension ContactsDataStoreTests {
    private func checkRemoving() {
        let contacts = contactsDataStore.getAllContacts()
        XCTAssert(contacts.isEmpty)
    }
    
    private func removeTestContacts() {
        contactsDataStore.deleteAll()
    }
}


// MARK: - Fake realm notification observer it shold be interactor or something else
// Example of usage
class FakeObserver {
    private let contactsDataStore: ContactsDataStoreServiceProtocol
    
    init(contactsDataStore: ContactsDataStoreServiceProtocol) {
        self.contactsDataStore = contactsDataStore
        
    }
    
    func startObserve() {
        contactsDataStore.observe { contacts in
            print("REALM \(contacts)")
        }
    }
}
