//
//  Signature.swift
//  UniversaWallet
//
//  Created by Даниил Мирошниченко on 05.07.2018.
//  Copyright © 2018 Universa. All rights reserved.
//

import Foundation
import secp256k1

class Signature {
    public static func sign(_ data: Data, privateKey: PrivateKey) throws -> Data {
        let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer { secp256k1_context_destroy(ctx) }
        
        let signature = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { signature.deallocate() }
        let status = data.withUnsafeBytes { (ptr: UnsafePointer<UInt8>) in
            privateKey.raw.withUnsafeBytes { secp256k1_ecdsa_sign(ctx, signature, ptr, $0, nil, nil) }
        }
        
        guard status == 1 else {
            throw SignError.signFailed
        }
        
        let normalizedsig = UnsafeMutablePointer<secp256k1_ecdsa_signature>.allocate(capacity: 1)
        defer { normalizedsig.deallocate() }
        secp256k1_ecdsa_signature_normalize(ctx, normalizedsig, signature)
        
        var length: size_t = 128
        var der = Data(count: length)
        guard der.withUnsafeMutableBytes({ return secp256k1_ecdsa_signature_serialize_der(ctx, $0, &length, normalizedsig) }) == 1 else {
            throw SignError.notEnoughSpace
        }
        
        der.count = length
        
        return der
    }
}

enum SignError: LocalizedError {
    case signFailed
    case notEnoughSpace
    
    var errorDescription: String? {
        switch self {
        case .signFailed:
            return "Failed to sign message"
        case .notEnoughSpace:
            return "Not enough space"
        }
    }
}



