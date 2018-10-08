//
//  ReceiverInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ReceiverInteractorOutput: class {
    func updateContacts(_ contacts: [ContactsSection])
    func updateEmpty(placeholderImage: UIImage, placeholderText: String)
}
