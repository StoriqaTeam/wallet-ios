//
//  SignHeaderProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SignHeaderFactoryProtocol {
    func createSignHeader(email: String) throws -> SignHeader
}


class SignHeaderFactory: SignHeaderFactoryProtocol {
    
    private let keychain: KeychainProviderProtocol
    private let defaults: DefaultsProviderProtocol
    private let signer: SignerProtocol
    private let userkeyManager: UserKeyManagerProtocol
    
    init(keychain: KeychainProviderProtocol,
         signer: SignerProtocol,
         defaults: DefaultsProviderProtocol,
         userkeyManager: UserKeyManagerProtocol) {
        self.keychain = keychain
        self.defaults = defaults
        self.signer = signer
        self.userkeyManager = userkeyManager
    }
    
    func createSignHeader(email: String) throws -> SignHeader {
        let deviceId = defaults.deviceId
        let timestamp = UInt64(Date().timeIntervalSince1970 * 1000)
        
        guard let privateKey = userkeyManager.getPrivateKeyFor(email: email) else {
            throw SignHeaderFactoryError.keychainEmpty
        }
        
        let publicKey = privateKey.publicKey()
        let message = "\(timestamp)"+deviceId
        
        guard let signature = signer.sign(message: message, privateKey: privateKey, useEncodeByte: false) else {
            throw SignHeaderFactoryError.failToSign
        }
        
        return SignHeader(deviceId: deviceId,
                          timestamp: "\(timestamp)",
                          signature: signature.hex,
                          pubKeyHex: publicKey.hex)
    }
}

enum SignHeaderFactoryError: Error, LocalizedError {
    case keychainEmpty
    case failToSign
    
    var errorDescription: String? {
        switch self {
        case .keychainEmpty:
            return "Private key no found in keychain"
        case .failToSign:
            return "Fail to sign header"
        }
    }
}
