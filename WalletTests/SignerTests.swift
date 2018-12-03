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
        
        XCTAssertEqual(_pubKeyHex, pubKey.hex)
        XCTAssertEqual(_signatureWithEncodeByteHex, signature.hex)
        XCTAssertEqual(signature.count, 65)
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
        
        XCTAssertEqual(_pubKeyHex, pubKey.hex)
        XCTAssertEqual(_signatureNoEncodeByteHex, signature.hex)
        XCTAssertEqual(signature.count, 64)
    }
    
    func testChangeMessage() {
        let privKeyData = Data(hexString: _privKeyHex)
        let privKey = PrivateKey(raw: privKeyData)
        let pubKey = privKey.publicKey()
        guard let signature = signer.sign(message: _messageToSign + "", privateKey: privKey, useEncodeByte: false) else {
            XCTFail("Fail to sign message with given private key")
            return
        }
        
        XCTAssertEqual(_pubKeyHex, pubKey.hex)
        XCTAssertEqual(_signatureNoEncodeByteHex, signature.hex)
    }
    
    func testSignHeader() {
        let ts = "1542629842123"
        let vendorId = "56a81d5d-c89c-4971-8bc1-a6101270d2ce"
        let message = ts+vendorId
        
        let privKeyData = Data(hexString: _privKeyHex)
        let privKey = PrivateKey(raw: privKeyData)
        let pubKey = privKey.publicKey()
        
        guard let signature = signer.sign(message: message, privateKey: privKey, useEncodeByte: false) else {
            XCTFail("Fail to sign message with given private key")
            return
        }
        
        print("\nMessage to sign: \(message)")
        print("Private key: \(privKey.hex)")
        print("Public key: \(pubKey.hex)")
        print("Sinature: \(signature.hex)\n")
        
        XCTAssertEqual(signature.count, 64)
    }
    
    func testSign() {
        let pubKeyHex = "048d1464c6fe2e814f751414c523003a7d4e18e4e6fe4cc3607a65ac7af286afd4a08ae54f32edfa38e6f6c450966b6767e786efd4ac3d4fdd72c23a90344dcf89"
        let signHex = "c22f95eb64109779369a5129a51c7b782ca8ba244e5bde84331ed4f3769420578d4a4d5cb680a7700f501aecfc891c67212480df8aacdad0ae8ad330e170dc5"
        
        
        let signData = Data(hexString: signHex)
        let pubKeyRaw = Data(hexString: pubKeyHex)
        let pubkey = PublicKey(raw: pubKeyRaw)
        
        let isValid = signer.verify(signature: signData, publicKey: pubkey, message: "15438302545168B9603FD-860A-414F-BDD0-A11B79BECDCA")
        print(isValid)
    }
    
}

