//
//  ContactsProvider.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Contacts

@objc class Contact: NSObject {
    @objc let givenName: String
    @objc let familyName: String
    let mobile: String
    let image: UIImage?
    
    lazy var clearedPhoneNumber = mobile.clearedPhoneNumber()
    lazy var name: String = givenName + (givenName.isEmpty ? "" : " ") + familyName
    
    init(givenName: String, familyName: String, mobile: String, imageData: Data?) {
        self.givenName = givenName
        self.familyName = familyName
        self.mobile = mobile
        
        if let imageData = imageData {
            self.image = UIImage(data: imageData)
        } else {
            self.image = nil
        }
    }
}

struct ContactsSection {
    let title: String
    let contacts: [Contact]
}

protocol ContactsProviderProtocol {
    func fetchContacts(completion: @escaping (Result<[ContactsSection]>)->())
    func searchContact(text: String) -> [ContactsSection]
}

class ContactsProvider: ContactsProviderProtocol {
    
    //TODO: message in info plist
    
    private var contacts: [Contact]?
    private var sortSelector: Selector?
    
    func fetchContacts(completion: @escaping (Result<[ContactsSection]>)->()) {
        let store = CNContactStore()
        
        store.requestAccess(for: (.contacts)) { [weak self] (granted, err) in
            guard let strongSelf = self else {
                return
            }
            
            if let err = err {
                //TODO: show smth on case of error
                log.warn("Failed to request access", err.localizedDescription)
                completion(Result.failure(err))
                return
            }
            
            if granted {
                print("Access granted")
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactThumbnailImageDataKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                fetchRequest.sortOrder = CNContactsUserDefaults.shared().sortOrder
                
                var contacts = [Contact]()
                
                do {
                    try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, error) -> Void in
                        
                        guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {return}
                        contacts.append(Contact(givenName: contact.givenName, familyName: contact.familyName, mobile: phoneNumber, imageData: contact.thumbnailImageData))
                        
                    })
                    
                    strongSelf.contacts = contacts
                    
                    let sortSelector: Selector
                    switch fetchRequest.sortOrder {
                    case .givenName:
                        sortSelector = #selector(getter: Contact.givenName)
                    default:
                        sortSelector = #selector(getter: Contact.familyName)
                    }
                    
                    strongSelf.sortSelector = sortSelector
                    
                    let sortedContacts = strongSelf.setUpCollation(contacts: contacts, sortOrderSelector: sortSelector)
                    let result = Result.success(sortedContacts)
                    completion(result)
                }
                catch let error as NSError {
                    completion(Result.failure(error))
                    log.warn(error.localizedDescription)
                }
                
                
            } else {
                //TODO: show smth on case of declined access
                let error = NSError(domain: "CNErrorDomain",
                                    code: 100,
                                    userInfo: ["NSLocalizedDescription": "Access Denied",
                                               "NSLocalizedFailureReason": "This application has not been granted permission to access Contacts."])
                completion(Result.failure(error))
                log.warn("Access denied")
            }
        }
    }
    
    func searchContact(text: String) -> [ContactsSection] {
        guard let contacts = contacts else {
            return []
        }
        
        let filtered: [Contact]
        if text.isEmpty {
            filtered = contacts
        } else {
            filtered = contacts.filter { (contact) -> Bool in
                //TODO: поиск по вхождению или по префиксу?
                let isNumber = contact.clearedPhoneNumber.contains(text.clearedPhoneNumber())
                let isName = contact.name.lowercased().contains(text.lowercased())
                return isNumber || isName
            }
        }
        
        let sorted = setUpCollation(contacts: filtered, sortOrderSelector: sortSelector ?? #selector(getter: Contact.familyName))
        return sorted
    }
}


//MARK: - Private methods

extension ContactsProvider {
    private func setUpCollation(contacts: [Contact], sortOrderSelector: Selector) -> [ContactsSection] {
        // create a locale collation object, by which we can get section index titles of current locale. (locale = local contry/language)
        let collation = UILocalizedIndexedCollation.current()
        let sections = collation.partitionContacts(array: contacts, collationStringSelector: sortOrderSelector)
        return sections
    }
}

private extension UILocalizedIndexedCollation {
    //func for partition array in sections
    func partitionContacts(array: [Contact], collationStringSelector: Selector) -> [ContactsSection] {
        var unsortedSections = [[Contact]]()
        
        //1. Create a array to hold the data for each section
        for _ in self.sectionTitles {
            unsortedSections.append([]) //appending an empty array
        }
        //2. Put each objects into a section
        for item in array {
            let index: Int = self.section(for: item, collationStringSelector:collationStringSelector)
            unsortedSections[index].append(item)
        }
        //3. sorting the array of each sections
        var sections = [ContactsSection]()
        for index in 0 ..< unsortedSections.count {
            if unsortedSections[index].count > 0 {
                let section = ContactsSection(title: self.sectionTitles[index],
                                              contacts: self.sortedArray(from: unsortedSections[index], collationStringSelector: collationStringSelector) as! [Contact])
                
                sections.append(section)
            }
        }
        return sections
    }
}
