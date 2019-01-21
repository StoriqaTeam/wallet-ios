//
//  DecimalToStringTests.swift
//  WalletTests
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


import XCTest
@testable import Wallet

class DecimalToStringTests: XCTestCase {

    func testStringToDecimal() {
        XCTAssertEqual("1234567890".decimalValue(), 1234567890)
        XCTAssertEqual("12.34567890".decimalValue(), Decimal(string: "12.3456789"))
        XCTAssertEqual("1234,567890".decimalValue(), Decimal(string: "1234.56789"))
        XCTAssertEqual(",".decimalValue(), 0)
        XCTAssertEqual(".".decimalValue(), 0)
        XCTAssertEqual("0.0".decimalValue(), 0)
        XCTAssertEqual("-0".decimalValue(), 0)
        XCTAssertEqual("-123456.7890".decimalValue(), Decimal(string: "-123456.789"))
        XCTAssertEqual("000 000 000 000".decimalValue(), 0)
        XCTAssertEqual("1 234 567 890".decimalValue(), 1234567890)
        XCTAssertEqual("1_234_567_890".decimalValue(), 1234567890)
        XCTAssertEqual("12dfgh34.567hh890ouj".decimalValue(), Decimal(string: "1234.567890"))
        XCTAssertEqual("".decimalValue(), 0)
    }
    
    func testDecimalToString() {
        let decimalSeparator = Locale.current.decimalSeparator!
        
        XCTAssertEqual(Decimal(1234567890).string, "1234567890")
        XCTAssertEqual(Decimal(00000001234567890).string, "1234567890")
        XCTAssertEqual(Decimal(string: "12.3456789")!.string, "12\(decimalSeparator)3456789")
        XCTAssertEqual(Decimal(string: "123456.789")!.string, "123456\(decimalSeparator)789")
        XCTAssertEqual(Decimal(string: "0000000.10000000000")!.string, "0\(decimalSeparator)1")
        XCTAssertEqual(Decimal(string: "-123456.123")!.string, "-123456\(decimalSeparator)123")
        XCTAssertEqual(Decimal(0).string, "0")
    }
    
    func testIsValidDecimal() {
        XCTAssertTrue("123456".isValidDecimal())
        XCTAssertTrue("123.456".isValidDecimal())
        XCTAssertTrue("1234,56".isValidDecimal())
        XCTAssertTrue("0000123456".isValidDecimal())
        XCTAssertTrue("000000".isValidDecimal())
        XCTAssertTrue("-123456".isValidDecimal())
        XCTAssertTrue("-123456.12345678976543".isValidDecimal())
        
        XCTAssertFalse("123qwertgh456".isValidDecimal())
        XCTAssertFalse("kjhgfd".isValidDecimal())
        XCTAssertFalse("11-11".isValidDecimal())
        XCTAssertFalse("12345.6,7.8,9.0.9,8.7,6.543".isValidDecimal())
    }
    
    func testRoundDecimal() {
        XCTAssertEqual(Decimal(string: "123456.7890")?.rounded(), Decimal(string: "123457"))
        XCTAssertEqual(Decimal(string: "123456.4890")?.rounded(), Decimal(string: "123456"))
        XCTAssertEqual(Decimal(string: "123456.1")?.rounded(), Decimal(string: "123456"))
        XCTAssertEqual(Decimal(string: "123456.8")?.rounded(), Decimal(string: "123457"))
    }
    

}
