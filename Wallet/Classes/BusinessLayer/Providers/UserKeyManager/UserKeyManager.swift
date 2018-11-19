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
    func setNewPrivateKey(email: String) -> PrivateKey?
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
        if let oldEmail = keychain.email {
            guard oldEmail == email else { return nil }
            return getPrivateKeyFromKeychain()
        }
        
        return nil
    }
    
    
    /// Creates new private key. Save private key and email to keychan.
    ///
    /// - Parameters:
    ///   - email: user email.
    /// - Returns: return generated private key, otherwise nil.
    
    func setNewPrivateKey(email: String) -> PrivateKey? {
        self.clearUserKeyData()
        
        guard let privateKey = try? keyGenerator.generatePrivKey() else { return nil }
        keychain.email = email
        keychain.privateKey = privateKey.hex
        
        return privateKey
    }
    
    func clearUserKeyData() {
        keychain.deleteUserKeys()
    }
}


// MARK: - Private methods

extension UserKeyManager {
    private func getPrivateKeyFromKeychain() -> PrivateKey? {
        guard let privKeyHex = keychain.privateKey else { return nil }
        let privKeyRaw = Data(hexString: privKeyHex)
        return PrivateKey(raw: privKeyRaw)
    }
}
