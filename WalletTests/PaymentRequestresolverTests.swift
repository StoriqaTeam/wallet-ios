//
//  PaymentRequestResolverTests.swift
//  WalletTests
//
//  Created by Storiqa on 18/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//


import XCTest
@testable import Wallet

class PaymentRequestResolverTests: XCTestCase {
    
    private struct PaymentRequestTestData {
        let string: String
        let paymentRequest: PaymentRequest?
    }
    
    // MARK: - Providers
    
    private let cryptoAddressResolver = CryptoAddressResolver(btcAddressValidator: BitcoinAddressValidator(network: .btcMainnet),
                                                              ethAddressValidator: EthereumAddressValidator())
    private var paymentRequestResolver: PaymentRequestResolverProtocol!
    
    
    // MARK: - Given
    
    private let ethSuccessString = "ethereum:0x4373C2E0BD17C1202E4D2Cd1b00fD1276a792670?amount=499"
    private var ethSussessPaymentRequest: PaymentRequestTestData!
    private let ethFailString_1 = "ethereum:0x4373C2E0BD17C1202E4D2Cd1b00fD1276a?amount=499"
    private var ethFailPaymentRequest_1: PaymentRequestTestData?
    private let ethFailString_2 = "bitcoin:0x4373C2E0BD17C1202E4D2Cd1b00fD1276a792670?amount=499"
    private var ethFailPaymentRequest_2: PaymentRequestTestData?
    private let ethFailString_3 = "ethereum:0x4373C2E0BD17C1202E4D2Cd1b00fD1276a792670?amount="
    private var ethFailPaymentRequest_3: PaymentRequestTestData?
    
    override func setUp() {
        super.setUp()
        self.paymentRequestResolver = PaymentRequestResolver(cryptoAddressResolver: cryptoAddressResolver)
        ethSussessPaymentRequest = PaymentRequestTestData(string: ethSuccessString,
                                                          paymentRequest: PaymentRequest(currency: .eth,
                                                                                         address: "0x4373C2E0BD17C1202E4D2Cd1b00fD1276a792670",
                                                                                         amount: 499))
        
        
    }
    
    func testSuccessPaymentRequest() {
        guard let paymentRequest = paymentRequestResolver.resolve(string: ethSuccessString) else {
            XCTFail("Fail to resolve payment request from string: \(ethSuccessString)")
            return
        }
        
        let testEthPaymentRequest = ethSussessPaymentRequest.paymentRequest!
        
        XCTAssertEqual(paymentRequest.address, testEthPaymentRequest.address)
        XCTAssertEqual(paymentRequest.amount, testEthPaymentRequest.amount)
        XCTAssertEqual(paymentRequest.currency, testEthPaymentRequest.currency)
    }
    
    func testFailPaymentRequest() {
        guard let _ = paymentRequestResolver.resolve(string: ethFailString_1) else {
            XCTAssert(true)
            return
        }
        
        XCTFail("Create fail payment request")
    }
    
    func testFailpaymentRequest_2() {
        guard let _ = paymentRequestResolver.resolve(string: ethFailString_2) else {
            XCTAssert(true)
            return
        }
        
        XCTFail("Create fail payment request")
    }
    
    func testFailpaymentRequest_3() {
        guard let _ = paymentRequestResolver.resolve(string: ethFailString_3) else {
            XCTAssert(true)
            return
        }
        
        XCTFail("Create fail payment request")
    }
}

