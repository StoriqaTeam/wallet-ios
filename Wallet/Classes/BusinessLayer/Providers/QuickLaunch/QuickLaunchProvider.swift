//
//  QuickLaunchProvider.swift
//  Wallet
//
//  Created by Storiqa on 19.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol QuickLaunchProviderProtocol {
    func isBiometryAvailable() -> Bool
    func getBiometryType() -> BiometricAuthType
    func setPin(_ pin: String)
    func isPinConfirmed(_ pinConfirmation: String) -> Bool
    func activateBiometryLogin()
}

class QuickLaunchProvider: QuickLaunchProviderProtocol {
    
    private let authData: AuthData
    private let token: String
    
    private var pin: String?
    
    private let defaultsProvider: DefaultsProviderProtocol
    private let keychainProvider: KeychainProviderProtocol
    private let biometricAuthProvider: BiometricAuthProviderProtocol
    
    init(authData: AuthData,
         token: String,
         defaultsProvider: DefaultsProviderProtocol,
         keychainProvider: KeychainProviderProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol) {
        
        self.authData = authData
        self.token = token
        self.defaultsProvider = defaultsProvider
        self.keychainProvider = keychainProvider
        self.biometricAuthProvider = biometricAuthProvider
    }
    
    func isBiometryAvailable() -> Bool {
        return biometricAuthProvider.canAuthWithBiometry
    }
    
    func setPin(_ pin: String) {
        self.pin = pin
    }
    
    func isPinConfirmed(_ pinConfirmation: String) -> Bool {
        if pin == pinConfirmation {
            keychainProvider.pincode = pin
            
            //TODO: save authData and token to keychain
            
            log.debug("//TODO: save authData and token to keychain")
            return true
        } else {
            pin = nil
            return false
        }
    }
    
    func getBiometryType() -> BiometricAuthType {
        return biometricAuthProvider.biometricAuthType
    }
    
    func activateBiometryLogin() {
        defaultsProvider.isBiometryAuthEnabled = true
        
        //TODO: save authData and token to keychain
        
        log.debug("//TODO: save authData and token to keychain")
    }
    
}
