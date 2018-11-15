//
//  KeyGenerator.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import CryptoSwift

protocol KeyGeneratorProtocol {
    func generatePrivKey() throws -> PrivateKey
}


class KeyGenerator: KeyGeneratorProtocol {
    
    func generatePrivKey() throws -> PrivateKey {
        let password = Constants.Crypto.PBKDF2.password
        let salt = Constants.Crypto.PBKDF2.salt
        
        guard let privKeyBytes = try? PKCS5.PBKDF2(password: password,
                                                   salt: salt, iterations: 4096,
                                                   variant: .sha256).calculate() else {
            throw KeyGeneratorError.failToGeneratePrivKey
        }
        
        let privKeyRaw = Data(bytes: privKeyBytes)
        return PrivateKey(raw: privKeyRaw)
    }
}


enum KeyGeneratorError: Error, LocalizedError {
    case failToGeneratePrivKey
    
    var errorDescription: String? {
        switch self {
        case .failToGeneratePrivKey:
            return "Fail to generate private key"
        }
    }
    
}
