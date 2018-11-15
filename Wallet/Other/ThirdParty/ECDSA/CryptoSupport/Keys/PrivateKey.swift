//
//  PrivateKey.swift
//  Wallet
//
//  Created by Storiqa on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct PrivateKey {
    
    public let raw: Data
    public let hex: String
    
    public init(raw: Data) {
        self.raw = raw
        self.hex = raw.toHexString()
    }
    
    func publicKey() -> PublicKey {
        let pubKeyRaw = Crypto.generatePublicKey(data: raw, compressed: false)
        return PublicKey(raw: pubKeyRaw)
    }
}
