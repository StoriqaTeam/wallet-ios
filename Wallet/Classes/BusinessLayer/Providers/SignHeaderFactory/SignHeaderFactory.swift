//
//  SignHeaderProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SignHeaderFactoryProtocol {
    func createSignHeader() throws -> SignHeader
}


class SignHeaderFactory: SignHeaderFactoryProtocol {
    
    private let keychain: KeychainProviderProtocol
    private let signer: SignerProtocol
    
    
    init(keychain: KeychainProviderProtocol, signer: SignerProtocol) {
        self.keychain = keychain
        self.signer = signer
    }
    
    func createSignHeader() throws -> SignHeader {
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let timestamp = Int(Date().timeIntervalSince1970)
        
        guard let privKeyHex = keychain.privateKey else {
            throw SignHeaderFactoryError.keychainEmpty
        }
        
        let privKeyRaw = Data(hexString: privKeyHex)
        let privateKey = PrivateKey(raw: privKeyRaw)
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


