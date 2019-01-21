//
//  CurrencyFormatterTests.swift
//  WalletTests
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import XCTest
@testable import Wallet

class CurrencyFormatterTests: XCTestCase {
    
    private let formatter = CurrencyFormatter()
    
    func testStringFromDecimal() {
        let testAmount = "1234567890".decimalValue()
        let groupingSeparator = Locale.current.groupingSeparator!
        
        let inSTQ = formatter.getStringFrom(amount: testAmount, currency: .stq)
        let inETH = formatter.getStringFrom(amount: testAmount, currency: .eth)
        let inBTC = formatter.getStringFrom(amount: testAmount, currency: .btc)
        let inFiat = formatter.getStringFrom(amount: testAmount, currency: .defaultFiat)
        
        
        XCTAssertEqual(inSTQ, "1\(groupingSeparator)234\(groupingSeparator)567\(groupingSeparator)890 \(Currency.stq.symbol)")
        XCTAssertEqual(inETH, "1\(groupingSeparator)234\(groupingSeparator)567\(groupingSeparator)890 \(Currency.eth.symbol)")
        XCTAssertEqual(inBTC, "1\(groupingSeparator)234\(groupingSeparator)567\(groupingSeparator)890 \(Currency.btc.symbol)")
        XCTAssertEqual(inFiat, "\(Currency.defaultFiat.symbol)1\(groupingSeparator)234\(groupingSeparator)567\(groupingSeparator)890")
        
        XCTAssertEqual(formatter.getStringFrom(amount: 0, currency: .stq), "0 \(Currency.stq.symbol)")
        XCTAssertEqual(formatter.getStringFrom(amount: -100, currency: .stq), "-100 \(Currency.stq.symbol)")
    }
    
    func testStringFromSmallDecimal() {
        let testAmount = "0.12345678901234567890".decimalValue()
        let decimalSeparator = Locale.current.decimalSeparator!
        
        let inSTQ = formatter.getStringFrom(amount: testAmount, currency: .stq)
        let inETH = formatter.getStringFrom(amount: testAmount, currency: .eth)
        let inBTC = formatter.getStringFrom(amount: testAmount, currency: .btc)
        let inFiat = formatter.getStringFrom(amount: testAmount, currency: .defaultFiat)
        
        
        XCTAssertEqual(inSTQ, "0\(decimalSeparator)123456789012345679 \(Currency.stq.symbol)")
        XCTAssertEqual(inETH, "0\(decimalSeparator)123456789012345679 \(Currency.eth.symbol)")
        XCTAssertEqual(inBTC, "0\(decimalSeparator)12345679 \(Currency.btc.symbol)")
        XCTAssertEqual(inFiat, "\(Currency.defaultFiat.symbol)0\(decimalSeparator)12")
    }
    
    func testStringFromDecimalWithoutCurrency() {
        let testAmount = "1234567890".decimalValue()
        
        let inSTQ = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .stq)
        let inETH = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .eth)
        let inBTC = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .btc)
        let inFiat = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .defaultFiat)
        
        
        XCTAssertEqual(inSTQ, "1234567890")
        XCTAssertEqual(inETH, "1234567890")
        XCTAssertEqual(inBTC, "1234567890")
        XCTAssertEqual(inFiat, "1234567890")
        
        XCTAssertEqual(formatter.getStringWithoutCurrencyFrom(amount: 0, currency: .stq), "0")
        XCTAssertEqual(formatter.getStringWithoutCurrencyFrom(amount: -100, currency: .stq), "-100")
    }
    
    func testStringFromSmallDecimalWithoutCurrency() {
        let testAmount = "0.12345678901234567890".decimalValue()
        let decimalSeparator = Locale.current.decimalSeparator!
        
        let inSTQ = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .stq)
        let inETH = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .eth)
        let inBTC = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .btc)
        let inFiat = formatter.getStringWithoutCurrencyFrom(amount: testAmount, currency: .defaultFiat)
        
        
        XCTAssertEqual(inSTQ, "0\(decimalSeparator)123456789012345679")
        XCTAssertEqual(inETH, "0\(decimalSeparator)123456789012345679")
        XCTAssertEqual(inBTC, "0\(decimalSeparator)12345679")
        XCTAssertEqual(inFiat, "0\(decimalSeparator)12")
    }
    
}
