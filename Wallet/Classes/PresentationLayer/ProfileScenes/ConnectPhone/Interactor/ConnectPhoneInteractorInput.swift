//
//  ConnectPhoneInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConnectPhoneInteractorInput: class {
    func getUserPhone() -> String
    func updateUserPhone(_ phone: String)
}
