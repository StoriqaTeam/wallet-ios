//
//  UserKeyManager.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol UserKeyManagerProtocol {
    func getPrivateKeyFor(email: String) -> PrivateKey?
    func addPrivateKeyIfNeeded(email: String) -> PrivateKey?
    func clearUserKeyData()
}


class UserKeyManager: UserKeyManagerProtocol {
    
    private let keychain: KeychainProviderProtocol
    private let keyGenerator: KeyGeneratorProtocol
    
    init(keychainProvider: KeychainProviderProtocol, keyGenerator: KeyGeneratorProtocol) {
        self.keychain = keychainProvider
        self.keyGenerator = keyGenerator
    }

    
    /// - Parameters:
    ///   - email: user email.
    /// - Returns: Private key for given email, if email mismatch with email in keychain
    ///            or no private key in keychain returns nil.
    
    func getPrivateKeyFor(email: String) -> PrivateKey? {
        let lowercasedEmail = email.lowercased()
        guard let pairs = keychain.privKeyEmail else { return nil }
        guard let privKeyHex = pairs[lowercasedEmail] else { return nil }
        return PrivateKey(raw: Data(hexString: privKeyHex))
    }
    
    
    /// Creates new private key. Save pair of private key and email to keychan.
    ///
    /// - Parameters:
    ///   - email: user email.
    /// - Returns: return generated private key, otherwise nil.
    
    func addPrivateKeyIfNeeded(email: String) -> PrivateKey? {
        
        if let privateKey = getPrivateKeyFor(email: email) {
            return privateKey
        }
        
        guard let privateKey = try? keyGenerator.generatePrivKey() else { return nil }
        
        if let pairs = keychain.privKeyEmail {
            var newPairs = pairs
            newPairs[email] = privateKey.hex
            keychain.privKeyEmail = newPairs
            return privateKey
        }
        
        keychain.privKeyEmail = [email: privateKey.hex]
        return privateKey
    }
    
    func clearUserKeyData() {
        keychain.deleteUserKeys()
    }
}
