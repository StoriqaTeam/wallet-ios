//
//  ContactsSorter.swift
//  Wallet
//
//  Created by Storiqa on 15/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Contacts


protocol ContactsSorterProtocol: class {
    func sort(contacts: [ContactDisplayable]) -> [ContactsSectionDisplayable]
    func searchContact(text: String, contacts: [ContactDisplayable]) -> [ContactsSectionDisplayable]
}

class ContactsSorter: ContactsSorterProtocol {
    
    private var sortSelector: Selector?
    
    func sort(contacts: [ContactDisplayable]) -> [ContactsSectionDisplayable] {
        let sortOrder = CNContactsUserDefaults.shared().sortOrder
        
        let sortSelector: Selector
        switch sortOrder {
        case .givenName:
            sortSelector = #selector(getter: ContactDisplayable.givenName)
        default:
            sortSelector = #selector(getter: ContactDisplayable.familyName)
        }
        
        let sorted = setUpCollation(contacts: contacts, sortOrderSelector: sortSelector)
        return sorted
    }
    
    func searchContact(text: String, contacts: [ContactDisplayable]) -> [ContactsSectionDisplayable] {
        let filtered: [ContactDisplayable]
        
        if text.isEmpty {
            filtered = contacts
        } else {
            filtered = contacts.filter { (contact) -> Bool in
                let lowercased = text.lowercased()
                let isName = contact.name.lowercased().contains(lowercased)
                
                if contact.id.isValidPhone(hasPlusPrefix: false) {
                    let clearedPhone = contact.id.clearedPhoneNumber()
                    let isNumber = clearedPhone.contains(text.clearedPhoneNumber())
                    return isNumber || isName
                } else if contact.id.isValidEmail() {
                    let isEmail = contact.id.lowercased().contains(lowercased)
                    return isEmail || isName
                } else {
                    log.error("contact id is neither phone nor email?!")
                    return false
                }
            }
        }
        
        let sorted = sort(contacts: filtered)
        return sorted
    }
    
}


// MARK: - Private methods

extension ContactsSorter {
    
    private func setUpCollation(contacts: [ContactDisplayable], sortOrderSelector: Selector) -> [ContactsSectionDisplayable] {
        // create a locale collation object, by which we can get section index titles of current locale
        let collation = UILocalizedIndexedCollation.current()
        let sections = collation.partitionContacts(array: contacts, collationStringSelector: sortOrderSelector)
        return sections
    }
    
}

private extension UILocalizedIndexedCollation {
    //func for partition array in sections
    func partitionContacts(array: [ContactDisplayable], collationStringSelector: Selector) -> [ContactsSectionDisplayable] {
        
        var unsortedSections = Array(repeating: [ContactDisplayable](), count: self.sectionTitles.count)
        
        for item in array {
            let index = self.section(for: item, collationStringSelector: collationStringSelector)
            unsortedSections[index].append(item)
        }
        
        var sections = [ContactsSectionDisplayable]()
        
        for index in 0 ..< unsortedSections.count where !unsortedSections[index].isEmpty {
            let sorted = self.sortedArray(from: unsortedSections[index],
                                          collationStringSelector: collationStringSelector)
            let section = ContactsSectionDisplayable(title: self.sectionTitles[index],
                                                     contacts: sorted as! [ContactDisplayable])
            
            sections.append(section)
        }
        
        return sections
    }
}
