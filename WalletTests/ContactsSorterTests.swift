//
//  ContactsSorterTests.swift
//  WalletTests
//
//  Created by Tata Gri on 15/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import XCTest
@testable import Wallet

class ContactsSorterTests: XCTestCase {
    
    private var contactsMapper: ContactsMapper!
    private var contactsSorter: ContactsSorter!
    
    override func setUp() {
        super.setUp()
        contactsMapper = ContactsMapper()
        contactsSorter = ContactsSorter()
    }
    
    func testSort() {
        let contacts = [Contact(id: "1",
                                givenName: "CName",
                                familyName: "CSurname",
                                cryptoAddress: nil,
                                imageData: nil),
                        Contact(id: "2",
                                givenName: "DddName",
                                familyName: "DddSurname",
                                cryptoAddress: nil,
                                imageData: nil),
                        Contact(id: "3",
                                givenName: "BName",
                                familyName: "BSurname",
                                cryptoAddress: nil,
                                imageData: nil),
                        Contact(id: "4",
                                givenName: "DName",
                                familyName: "DSurname",
                                cryptoAddress: nil,
                                imageData: nil)].map { contactsMapper.map(from: $0) }
        let sortedSections = contactsSorter.sort(contacts: contacts)
        
        XCTAssertEqual(sortedSections.map({ $0.title }),
                       ["B", "C", "D"],
                       "Wrong section title or order")
        XCTAssertEqual(sortedSections.map({ $0.contacts.count }),
                       [1, 1, 2],
                       "Contacts sections devision incorrect")
        XCTAssertEqual(sortedSections.flatMap({ $0.contacts }).map({ $0.id }),
                       ["3", "1", "2", "4"],
                       "Sorted contacts cound does not match initial count")
        
    }
    
    func testSearch() {
        let contacts = [Contact(id: "+1-(123)-456-78-90",
                                givenName: "CName",
                                familyName: "CSurname",
                                cryptoAddress: nil,
                                imageData: nil),
                        Contact(id: "testEmail@test.com",
                                givenName: "DddName",
                                familyName: "DddSurname",
                                cryptoAddress: nil,
                                imageData: nil),
                        Contact(id: "98765432154224",
                                givenName: "BName",
                                familyName: "BSurname",
                                cryptoAddress: nil,
                                imageData: nil),
                        Contact(id: "12398756735635",
                                givenName: "DName",
                                familyName: "DSurname",
                                cryptoAddress: nil,
                                imageData: nil)].map { contactsMapper.map(from: $0) }
        
        var filtered = contactsSorter.searchContact(text: "", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       4,
                       "All contacts must be shown on empty search")
        
        filtered = contactsSorter.searchContact(text: "Name", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       4,
                       "All contacts must be shown on 'Name' search")
        
        filtered = contactsSorter.searchContact(text: "SuRnaMe", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       4,
                       "All contacts must be shown on 'SuRnaMe' search")
        
        filtered = contactsSorter.searchContact(text: "dNAME", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       2,
                       "2 contacts must be shown on 'dNAME' search")
        
        filtered = contactsSorter.searchContact(text: "123", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       2,
                       "2 contacts must be shown on '123' search")
        
        filtered = contactsSorter.searchContact(text: "(123)", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       2,
                       "2 contacts must be shown on '123' search")
        
        filtered = contactsSorter.searchContact(text: "(987", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       2,
                       "2 contacts must be shown on '(987' search")
        
        filtered = contactsSorter.searchContact(text: "12345", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       1,
                       "1 contact must be shown on '12345' search")
        
        filtered = contactsSorter.searchContact(text: "test.com", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       1,
                       "1 contact must be shown on 'test.com' search")
        
        filtered = contactsSorter.searchContact(text: "sdfgvsdfgsfgfsgsdrfgdsg", contacts: contacts)
        XCTAssertEqual(filtered.flatMap({ $0.contacts }).count,
                       0,
                       "No contacts must be shown on 'sdfgvsdfgsfgfsgsdrfgdsg' search")
        
    }
}
