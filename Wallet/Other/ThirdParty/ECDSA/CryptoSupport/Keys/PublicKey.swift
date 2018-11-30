//
//  PublicKey.swift
//  Wallet
//
//  Created by Storiqa on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct PublicKey {
    
    public let raw: Data
    public let hex: String
    
    public init(raw: Data) {
        self.raw = raw
        self.hex = raw.toHexString()
    }
    
    public init(privateKey: PrivateKey) {
        let pubKeyRaw = Crypto.generatePublicKey(data: privateKey.raw, compressed: false)
        self.init(raw: pubKeyRaw)
    }
}
