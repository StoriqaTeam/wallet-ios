//
//  Contact.swift
//  Wallet
//
//  Created by user on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

@objc class Contact: NSObject {
    @objc let givenName: String
    @objc let familyName: String
    let mobile: String
    let image: UIImage?
    
    lazy var clearedPhoneNumber: String = mobile.clearedPhoneNumber()
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
