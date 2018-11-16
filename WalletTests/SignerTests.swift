//
//  SignerTests.swift
//  WalletTests
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import XCTest
@testable import Wallet


class SighnerTests: XCTestCase {
    let signer = Signer()
    
    // MARK: - Given
    let _privKeyHex = "b920a5cb91c601c6bf7e32974e29d7ebbe591d63f67de40f0a2340525960bf8e"
    let _pubKeyHex = "04902c233712a54d20edabd9b80ebb75700819db8d0edad74a25e061c925fbeb27a4cc2090dd6b74fdb916bc7c503e18680da81828ecddd5939020cc855ada18da"
    let _messageToSign = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque molestie odio at scelerisque mollis. Morbi vitae faucibus urna. Vivamus hendrerit eros at egestas dictum"
    let _signatureWithEncodeByteHex = "aec73341d6bf70ef1b317d7f5461711dfcf94ed048671ecbb820b03a85139d535d86807814c352ce9859c08cbf945bd3f1769f25572d8058d10b142c1ed2831d01"
    let _signatureNoEncodeByteHex = "aec73341d6bf70ef1b317d7f5461711dfcf94ed048671ecbb820b03a85139d535d86807814c352ce9859c08cbf945bd3f1769f25572d8058d10b142c1ed2831d"
    
    
    override func setUp() {
        super.setUp()
    }
    
    func testSignerWithEncodeByte() {
        let privKeyData = Data(hexString: _privKeyHex)
        let privKey = PrivateKey(raw: privKeyData)
        let pubKey = privKey.publicKey()
        guard let signature = signer.sign(message: _messageToSign, privateKey: privKey, useEncodeByte: true) else {
            XCTFail("Fail to sign message with given private key")
            return
        }
        
        let isVerified = signer.verify(signature: signature, publicKey: pubKey, message: _messageToSign)
        
        XCTAssert(_pubKeyHex == pubKey.hex, "Fail to derive public key from string")
        XCTAssert(_signatureWithEncodeByteHex == signature.hex, "Fail to sign message with given private key")
        XCTAssert(signature.count == 65, "Signature lenght != 65 byte")
        XCTAssert(isVerified, "Fail to verify signature");
    }
    
    func testSignerNoEncodeByte() {
        let privKeyData = Data(hexString: _privKeyHex)
        let privKey = PrivateKey(raw: privKeyData)
        let pubKey = privKey.publicKey()
        guard let signature = signer.sign(message: _messageToSign, privateKey: privKey, useEncodeByte: false) else {
            XCTFail("Fail to sign message with given private key")
            return
        }
        
        XCTAssert(_pubKeyHex == pubKey.hex, "Fail to derive public key from string")
        XCTAssert(_signatureNoEncodeByteHex == signature.hex, "Fail to sign message with given private key")
        XCTAssert(signature.count == 64, "Signature lenght != 65 byte")
    }
    
    func testChangeMessage() {
        let privKeyData = Data(hexString: _privKeyHex)
        let privKey = PrivateKey(raw: privKeyData)
        let pubKey = privKey.publicKey()
        guard let signature = signer.sign(message: _messageToSign + "", privateKey: privKey, useEncodeByte: false) else {
            XCTFail("Fail to sign message with given private key")
            return
        }
        
        XCTAssert(_pubKeyHex == pubKey.hex, "Fail to derive public key from string")
        XCTAssert(_signatureNoEncodeByteHex == signature.hex, "Fail to sign message with given private key")
    }
    
    func testSignHeader() {
        let ts = "1542376150"
        let vendorId = "62231b8c-9ae7-4f6f-b18b-4b4836670e1a"
        let message = ts+vendorId
        
        let privKeyData = Data(hexString: _privKeyHex)
        let privKey = PrivateKey(raw: privKeyData)
        
        guard let signature = signer.sign(message: message, privateKey: privKey, useEncodeByte: false) else {
            XCTFail("Fail to sign message with given private key")
            return
        }
        
        XCTAssert(signature.count == 64, "Signature lenght != 64 byte")
    }
    
}
