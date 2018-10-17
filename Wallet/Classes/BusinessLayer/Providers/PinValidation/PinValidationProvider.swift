//
//  PinValidationProvider.swift
//  Wallet
//
//  Created by Storiqa on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PinValidationProviderProtocol {
    func pinIsValid(_ pin: String) -> Bool
    func resetPin()
}

class PinValidationProvider: PinValidationProviderProtocol {
    
    private let keychainProvider: KeychainProviderProtocol
    
    init(keychainProvider: KeychainProviderProtocol) {
        self.keychainProvider = keychainProvider
    }
    
    func pinIsValid(_ pin: String) -> Bool {
        guard let correctPin = keychainProvider.pincode else {
            return false
        }
        
        return pin == correctPin
    }
    
    func resetPin() {
        keychainProvider.pincode = nil
    }
    
}
