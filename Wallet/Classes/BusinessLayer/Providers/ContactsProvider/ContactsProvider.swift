//
//  ContactsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 10/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ContactsProviderProtocol {
    // @dev returns nil if nocontact at given address
    func getContact(address: String) -> Contact?
}


class ContactsProvider: ContactsProviderProtocol {
    func getContact(address: String) -> Contact? {
        fatalError("returns nil")
    }
}


class FakeContactsProvider: ContactsProviderProtocol {
    let contactsStorage: [Contact] = [Contact(givenName: "Satoshi",
                                              familyName: "Nalamoto",
                                              mobile: "8-925-342-43-76",
                                              cryptoAddress: "3J98t1WpEZ73CNmQviecrnyiWrnqRhWNLy",
                                              imageData: nil),
                                      
                                      Contact(givenName: "Vitaly",
                                              familyName: "Buterin",
                                              mobile: "8-985-644-65-71",
                                              cryptoAddress: "0x6f50c6bff08ec925232937b204b0ae23c488402a",
                                              imageData: nil)]
    
    func getContact(address: String) -> Contact? {
        return contactsStorage.first(where: { $0.cryptoAddress == address })
    }
}
