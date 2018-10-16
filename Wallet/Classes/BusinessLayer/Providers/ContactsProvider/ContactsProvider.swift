//
//  ContactsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ContactsProviderProtocol {
    // @dev returns nil if no contact at given address
    func getContact(address: String) -> ContactDisplayable?
}


class ContactsProvider: ContactsProviderProtocol {
    func getContact(address: String) -> ContactDisplayable? {
        fatalError("returns nil")
    }
}


class FakeContactsProvider: ContactsProviderProtocol {
    let contactsStorage = [ContactDisplayable(contact: Contact(id: "8-925-342-43-76",
                                                               givenName: "Satoshi",
                                                               familyName: "Nakamoto",
                                                               cryptoAddress: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy",
                                                               image: nil)),
                           
                           ContactDisplayable(contact: Contact(id: "8-985-644-65-71",
                                                               givenName: "Vitaly",
                                                               familyName: "Buterin",
                                                               cryptoAddress: "0x6f50c6bff08ec925232937b204b0ae23c488402a",
                                                               image: nil))]
    
    func getContact(address: String) -> ContactDisplayable? {
        return contactsStorage.first(where: { $0.cryptoAddress == address })
    }
}
