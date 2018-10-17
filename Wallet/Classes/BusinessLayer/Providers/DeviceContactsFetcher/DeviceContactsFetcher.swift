//
//  DeviceContactsFetcher.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Contacts


protocol DeviceContactsFetcherProtocol {
    func fetchContacts(completion: @escaping (Result<[Contact]>) -> Void)}

class DeviceContactsFetcher: DeviceContactsFetcherProtocol {
    
    //TODO: message in info plist
    
    func fetchContacts(completion: @escaping (Result<[Contact]>) -> Void) {
        let store = CNContactStore()
        
        store.requestAccess(for: (.contacts)) { (granted, err) in

            if let err = err {
                completion(Result.failure(err))
                return
            }
            
            if granted {
                let keys = [CNContactGivenNameKey,
                            CNContactFamilyNameKey,
                            CNContactPhoneNumbersKey,
                            CNContactThumbnailImageDataKey,
                            CNContactEmailAddressesKey]
                let fetchRequest = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                var contacts = [Contact]()
                
                do {
                    try store.enumerateContacts(with: fetchRequest, usingBlock: { ( contact, _) in
                        
                        let phones = contact.phoneNumbers.compactMap { (phone) -> String? in
                            let phone = phone.value.stringValue
                            return phone.isValidPhone(hasPlusPrefix: false) ? phone : nil
                        }
                        
                        let emails = contact.emailAddresses.compactMap { (email) -> String? in
                            let email = email.value as String
                            return email.isValidEmail() ? email : nil
                        }
                        
                        let identifiers = phones + emails
                        
                        identifiers.forEach { (identifier) in
                            let contact = Contact(id: identifier,
                                                  givenName: contact.givenName,
                                                  familyName: contact.familyName,
                                                  cryptoAddress: nil,
                                                  imageData: contact.thumbnailImageData)
                            contacts.append(contact)
                        }
                    })
                    
                    completion(Result.success(contacts))
                } catch {
                    let error = DeviceContactsFetcherError.failToAccessContacts
                    completion(Result.failure(error))
                    log.warn(error.localizedDescription)
                }
                
            } else {
                let error = DeviceContactsFetcherError.accessDenied
                completion(Result.failure(error))
            }
        }
    }
}


enum DeviceContactsFetcherError: LocalizedError {
    case failToAccessContacts
    case accessDenied
    
    var localizedDescription: String {
        switch self {
        case .failToAccessContacts:
            return "Fail to access contacts"
        case .accessDenied:
            return "This application has not been granted permission to access Contacts"
        }
    }
}
