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
