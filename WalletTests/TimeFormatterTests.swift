//
//  TimeFormatterTests.swift
//  WalletTests
//
//  Created by Storiqa on 14/01/2019.
//  Copyright © 2019 Storiqa. All rights reserved.
//

import Foundation

import XCTest
@testable import Wallet

class TimeFormatterTests: XCTestCase {
    private let timeFormatter = TimeFormatter()
    
    func testTimeFormatter() {
        XCTAssertEqual(timeFormatter.stringValue(from: 60), "1 min")
        XCTAssertEqual(timeFormatter.stringValue(from: 61), "1 min 1 sec")
        XCTAssertEqual(timeFormatter.stringValue(from: 0), "0 sec")
        XCTAssertEqual(timeFormatter.stringValue(from: 1), "1 sec")
        XCTAssertEqual(timeFormatter.stringValue(from: 3602), "60 min 2 sec")
        XCTAssertEqual(timeFormatter.stringValue(from: 3600), "60 min")
    }
}
