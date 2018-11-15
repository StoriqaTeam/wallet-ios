//
//  Crypto.swift
//  Wallet
//
//  Created by Даниил Мирошниченко on 15/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

import CryptoSwift
import secp256k1

public enum CryptoError: Error {
    case failedToSign
}

/// Helper class for cryptographic algorithms.
public final class Crypto {
    
    /// Generates public key from private key using secp256k1 elliptic curve math
    ///
    /// - Parameters:
    ///   - data: private key
    ///   - compressed: whether public key should be compressed
    /// - Returns: 65-byte key if not compressed, otherwise 33-byte public key.
//    public static func generatePublicKey(data: Data, compressed: Bool) -> Data {
//        return Secp256k1.generatePublicKey(withPrivateKey: data, compression: compressed)
//    }
//    
    /// Signs hash with private key
    ///
    /// - Parameters:
    ///   - hash: Hash of a message (32-byte data = 256-bit hash)
    ///   - privateKey: serialized private key based on secp256k1 algorithm
    /// - Returns: 65-byte signature of the hash data
    /// - Throws: EthereumKitError.failedToSign in case private key was invalid
    public static func sign(_ hash: Data, privateKey: Data) throws -> Data {
        let encrypter = EllipticCurveEncrypterSecp256k1()
        guard var signatureInInternalFormat = encrypter.sign(hash: hash, privateKey: privateKey) else {
            throw CryptoError.failedToSign
        }
        return encrypter.export(signature: &signatureInInternalFormat)
    }
    
    /// Validates a signature of a hash with publicKey. If valid, it guarantees that the hash was signed by the
    /// publicKey's private key.
    ///
    /// - Parameters:
    ///   - signature: hash's signature (65-byte)
    ///   - hash: 32-byte (256-bit) hash of a message
    ///   - publicKey: public key data in either compressed (then it is 33 bytes) or uncompressed (65 bytes) form
    ///   - compressed: whether public key is compressed
    /// - Returns: True, if signature is valid for the hash and public key, false otherwise.
    public static func isValid(signature: Data, of hash: Data, publicKey: Data, compressed: Bool) -> Bool {
        guard let recoveredPublicKey = self.publicKey(signature: signature, of: hash, compressed: compressed) else { return false }
        return recoveredPublicKey == publicKey
    }
    
    /// Calculates public key by a signature of a hash.
    ///
    /// - Parameters:
    ///   - signature: hash's signature (65-byte)
    ///   - hash: 32-byte (256-bit) hash of a message
    ///   - compressed: whether public key is compressed
    /// - Returns: 65-byte key if not compressed, otherwise 33-byte public key.
    public static func publicKey(signature: Data, of hash: Data, compressed: Bool) -> Data? {
        let encrypter = EllipticCurveEncrypterSecp256k1()
        var signatureInInternalFormat = encrypter.import(signature: signature)
        guard var publicKeyInInternalFormat = encrypter.publicKey(signature: &signatureInInternalFormat, hash: hash) else { return nil }
        return encrypter.export(publicKey: &publicKeyInInternalFormat, compressed: compressed)
    }
    
}
