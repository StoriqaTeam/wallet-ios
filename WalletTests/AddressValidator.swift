//
//  AddressValidator.swift
//  WalletTests
//
//  Created by Storiqa on 28.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import XCTest
@testable import Wallet

class AddressValidator: XCTestCase {
    
    // Providers
    
    var btcAddressValidator: AddressValidatorProtocol!
    var ethAddressValidator: AddressValidatorProtocol!
    var addressResolver: CryptoAddressResolverProtocol!
    
    // MARK: - Given
    
    let btcValidAddressesMainnet = [
                                    "1QC8Wax1H4obQAo3FE1cawXgzwy7GZNd6V",
                                    "1EStjAD37Xc18ynaF5dti468AZfM7924HK",
                                    "1xJBQjtg8YYzgVZ8htvknGiK7tbYAF9KD",
                                    "1AVLzTVxCvbTa37ThqEPcTkjmuwpw4uCyY"
                                   ]
    
    let btcFailedAddressesMainnet = [
                                    "1QC8Wax1H4obQAo3FE1cawXgzwy7GZNd6V1",
                                    "MMVLzTVxCvbTa37ThqEPcTkjmuwpw4uCyY",
                                    "0x7E0AfbeAb5ac7E13d4646bC10c5547e69b4AdD4E",
                                    "2EStjAD37Xc18ynaF5dti468AZfM7924H"
                                    ]
    
    
    let ethValidAddressesMainnet = [
                                    "0xC6A9759C9A8Ede6698CF33E709907b6F9c502aA8",
                                    "0x7E0AfbeAb5ac7E13d4646bC10c5547e69b4AdD4E",
                                    "0x39d7647073DD8FC590960930d883880e34052ee5",
                                    "0x9Cc539183De54759261Ef0ee9B3Fe91AEB85407F"
                                   ]
    
    let ethFailedAddressesMainnet = [
                                     "0xC6A9759C9A8Ede6698CF33E709907b6F9c502aA",
                                     "1EStjAD37Xc18ynaF5dti468AZfM7924HK",
                                     "0x9Cc539183De54759261Ef0ee9B3Fe91AEB85407F1",
                                     "119Cc539183De54759261Ef0ee9B3Fe91AEB85407F"
                                    ]
    
    override func setUp() {
        super.setUp()
        btcAddressValidator = BitcoinAddressValidator(network: .btcMainnet)
        ethAddressValidator = EthereumAddressValidator()
        addressResolver = CryptoAddressResolver(btcAddressValidator: btcAddressValidator,
                                                ethAddressValidator: ethAddressValidator)
        
    }
    
    func testBtcValidator() {
        for validDddr in btcValidAddressesMainnet {
            let isValid = btcAddressValidator.isValid(address: validDddr)
            XCTAssert(isValid, "Failed to validate address \(validDddr)")
        }
        
        for failedAddress in btcFailedAddressesMainnet {
            let isValid = btcAddressValidator.isValid(address: failedAddress)
            XCTAssert(!isValid, "Failed to validate address \(failedAddress)")
        }
        
    }
    
    func testEthValidator() {
        for validDddr in ethValidAddressesMainnet {
            let isValid = ethAddressValidator.isValid(address: validDddr)
            XCTAssert(isValid, "Failed to validate address \(validDddr)")
        }
        
        for failedAddress in ethFailedAddressesMainnet {
            let isValid = ethAddressValidator.isValid(address: failedAddress)
            XCTAssert(!isValid, "Failed to validate address \(failedAddress)")
        }
    }
    
    func testAddressResolver() {
        for btcAddress in btcValidAddressesMainnet {
            let resolve = addressResolver.resove(address: btcAddress)
            guard let currency = resolve else {
                XCTFail("Fail to resolve btc address")
                return
            }
            
            XCTAssert(currency == .btc, "Failed to resolve address \(btcAddress)")
        }
        
        for ethAddress in ethValidAddressesMainnet {
            let resolve = addressResolver.resove(address: ethAddress)
            guard let currency = resolve else {
                XCTFail("Fail to resolve eth address")
                return
            }
            
            XCTAssert(currency == .eth, "Failed to ethereum address \(ethAddress)")
        }
    }
}
