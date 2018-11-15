//
//  Signer.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SignerProtocol {
    func sign(message: String, privateKey: PrivateKey) -> Data?
    func verify(signature: Data, publicKey: PublicKey, message: String) -> Bool
}

class Signer: SignerProtocol {
    
    func sign(message: String, privateKey: PrivateKey) -> Data? {
        let hashedMessage = message.sha256()
        let hashedData = Data(hex: hashedMessage)
        let privKeyRaw = privateKey.raw
        
        guard let signature = try? Crypto.sign(hashedData, privateKey: privKeyRaw) else {
            log.error("Fail to sign message \(message)")
            return nil
        }
        
        return signature
    }
    
    
    func verify(signature: Data, publicKey: PublicKey, message: String) -> Bool {
        let hashedMessage = message.sha256()
        let hashedData = Data(hex: hashedMessage)
        let pubKeyRaw = publicKey.raw
        
        return Crypto.isValid(signature: signature, of: hashedData, publicKey: pubKeyRaw, compressed: false)
    }
}
