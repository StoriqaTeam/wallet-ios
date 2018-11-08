//
//  DenominationUnitsConverterTests.swift
//  WalletTests
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import XCTest
@testable import Wallet

class DenominationUnitsConverterTests: XCTestCase {

    private let unitConverter = DenominationUnitsConverter()
    
    func testAmountToMaxUnits() {
        XCTAssertEqual(unitConverter.amountToMaxUnits(Decimal(string: "12345678901234567890")!, currency: .stq), Decimal(string: "12.345678901234567890")!)
        XCTAssertEqual(unitConverter.amountToMaxUnits(Decimal(string: "12345678901234567890")!, currency: .eth), Decimal(string: "12.345678901234567890")!)
        XCTAssertEqual(unitConverter.amountToMaxUnits(Decimal(string: "12345678901234567890")!, currency: .btc), Decimal(string: "123456789012.34567890")!)
        XCTAssertEqual(unitConverter.amountToMaxUnits(Decimal(string: "12345678901234567890")!, currency: .fiat), Decimal(string: "12345678901234567890")!)
    }
    
    func testAmountToMinUnits() {
        XCTAssertEqual(unitConverter.amountToMinUnits(Decimal(string: "0.12345678901234567890")!, currency: .stq), Decimal(string: "123456789012345678.90")!)
        XCTAssertEqual(unitConverter.amountToMinUnits(Decimal(string: "0.12345678901234567890")!, currency: .eth), Decimal(string: "123456789012345678.90")!)
        XCTAssertEqual(unitConverter.amountToMinUnits(Decimal(string: "0.12345678901234567890")!, currency: .btc), Decimal(string: "12345678.901234567890")!)
        XCTAssertEqual(unitConverter.amountToMinUnits(Decimal(string: "0.12345678901234567890")!, currency: .fiat), Decimal(string: "0.12345678901234567890")!)
    }

}
