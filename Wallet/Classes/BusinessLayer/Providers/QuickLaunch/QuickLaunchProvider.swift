//
//  QuickLaunchProvider.swift
//  Wallet
//
//  Created by user on 19.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol QuickLaunchProviderProtocol {
    func isTouchIdAvailable() -> Bool
    func setPin(_ pin: String)
    func isPinConfirmed(_ pinConfirmation: String) -> Bool
    func activateBiometryLogin()
}

class QuickLaunchProvider: QuickLaunchProviderProtocol {
    
    private let email: String
    private let password: String
    
    private var pin: String?
    
    //FIXME: use KeychainProviderProvider when available
    private let keychainProvider: KeychainProvider
    private let biometricAuthProvider: BiometricAuthProviderProtocol
    
    init(authData: AuthData, keychainProvider: KeychainProvider, biometricAuthProvider: BiometricAuthProviderProtocol) {
        self.email = authData.email
        self.password = authData.password
        self.keychainProvider = keychainProvider
        self.biometricAuthProvider = biometricAuthProvider
    }
    
    func isTouchIdAvailable() -> Bool {
        return biometricAuthProvider.canAuthWithBiometry
    }
    
    func setPin(_ pin: String) {
        self.pin = pin
    }
    
    func isPinConfirmed(_ pinConfirmation: String) -> Bool {
        if pin == pinConfirmation {
            keychainProvider.pincode = pin
            return true
        } else {
            pin = nil
            return false
        }
    }
    
    func activateBiometryLogin() {
        //TODO: save login and password to keychain
        
    }
    
}
