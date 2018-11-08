//
//  ContactsMapper.swift
//  Wallet
//
//  Created by Storiqa on 15/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ContactsMapper: Mappable {
    func map(from obj: Contact) -> ContactDisplayable {
        return ContactDisplayable(contact: obj)
    }
}
