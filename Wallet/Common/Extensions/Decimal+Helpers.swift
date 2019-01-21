//
//  Decimal+Helpers.swift
//  Wallet
//
//  Created by Storiqa on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Decimal {
    
    static var pointFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        return formatter
    }()
    
    static var commaFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        return formatter
    }()
    
    init(_ float: Float) {
        let dec = NSNumber(value: float)
        self = dec.decimalValue
    }
    
    var string: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        formatter.maximumFractionDigits = 18
        return formatter.string(for: self)!
    }
    
    var double: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
    
    var float: Float {
        return NSDecimalNumber(decimal: self).floatValue
    }
    
    var int64: Int64 {
        return NSDecimalNumber(decimal: self).int64Value
    }
    
    var int: Int {
        return NSDecimalNumber(decimal: self).intValue
    }
    
    var uint64: UInt64 {
        return NSDecimalNumber(decimal: self).uint64Value
    }
    
    func humanReadable(_ digits: Int) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.locale = Locale(identifier: "us")
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = digits
        currencyFormatter.minimumFractionDigits = 0
        return currencyFormatter.string(for: self) ?? "0"
    }
    
    func rounded() -> Decimal {
        let rounded = NSDecimalNumber(decimal: self).rounding(accordingToBehavior: nil)
        return rounded.decimalValue
    }
    
}
