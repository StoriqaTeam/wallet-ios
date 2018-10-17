//
//  ContactDisplayable.swift
//  Wallet
//
//  Created by Storiqa on 15/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


struct ContactsSectionDisplayable {
    let title: String
    let contacts: [ContactDisplayable]
}


class ContactDisplayable: NSObject {
    let contact: Contact
    
    let id: String
    @objc let givenName: String
    @objc let familyName: String
    let cryptoAddress: String?
    let image: UIImage?
    let name: String
    
    init(contact: Contact) {
        self.contact = contact
        self.id = contact.id
        self.givenName = contact.givenName
        self.familyName = contact.familyName
        self.cryptoAddress = contact.cryptoAddress
        self.image = contact.image
        
        name = givenName + (givenName.isEmpty ? "" : " ") + familyName
    }
}
