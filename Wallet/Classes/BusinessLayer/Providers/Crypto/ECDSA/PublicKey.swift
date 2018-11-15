//
//  PublicKey.swift
//  Wallet
//
//  Created by Даниил Мирошниченко on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

/// Represents a public key
public struct PublicKey {
    
    /// Public key in data format
    public let raw: Data
    
    public init(raw: Data) {
        self.raw = raw
    }
    
    public init(privateKey: PrivateKey) {
        self.init(raw: Data(hex: "0x") + PublicKey.from(data: privateKey.raw, compressed: false))
    }
    
    /// Generates public key from specified private key,
    ///
    /// - Parameters: data of private key and compressed
    /// - Returns: Public key in data format
    public static func from(data: Data, compressed: Bool) -> Data {
        fatalError("Needs to implement")
//        return Crypto.generatePublicKey(data: data, compressed: compressed)
    }
}
