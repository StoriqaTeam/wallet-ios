//
//  Contact.swift
//  Wallet
//
//  Created by user on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation

struct Contact {
    let id: String
    let givenName: String
    let familyName: String
    var cryptoAddress: String?
    var image: UIImage?
    
    mutating func setCryptoAddress(address: String?) {
        self.cryptoAddress = address
    }
    
    init(id: String,
         givenName: String,
         familyName: String,
         cryptoAddress: String?,
         imageData: Data?) {
        
        self.id = id
        self.givenName = givenName
        self.familyName = familyName
        self.cryptoAddress = cryptoAddress
        
        if let imageData = imageData {
            let image = UIImage(data: imageData)
            self.image = image
        } else {
            self.image = nil
        }
    }
}

// MARK: - RealmMappable

extension Contact: RealmMappable {
    init(_ object: RealmContact) {
        self.init(id: object.id,
                  givenName: object.givenName,
                  familyName: object.familyName,
                  cryptoAddress: object.cryptoAddress,
                  imageData: object.image)
    }
    
    func mapToRealmObject() -> RealmContact {
        let object = RealmContact()
        
        object.id = self.id
        object.givenName = self.givenName
        object.familyName = self.familyName
        object.cryptoAddress = self.cryptoAddress
        object.image = self.image?.data()
        
        return object
    }
}
