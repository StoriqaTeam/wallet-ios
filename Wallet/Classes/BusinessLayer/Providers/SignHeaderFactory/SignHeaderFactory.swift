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
    private let signer: SignerProtocol
    
    
    init(keychain: KeychainProviderProtocol, signer: SignerProtocol) {
        self.keychain = keychain
        self.signer = signer
    }
    
    func createSignHeader(email: String) throws -> SignHeader {
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let timestamp = UInt64(Date().timeIntervalSince1970 * 1000)
        
        guard let privateKey = getPrivateKey(email: email) else {
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


// MARK: - Private methods

extension SignHeaderFactory {
    
    private func getPrivateKey(email: String) -> PrivateKey? {
        guard let pairs = keychain.privKeyEmail else { return nil }
        guard let privKeyHex = pairs[email] else { return nil }
        return PrivateKey(raw: Data(hexString: privKeyHex))
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
