//
//  Decimal+Helpers.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 05/10/2018.
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
    
    static func number(fromInput: String) -> Decimal {
        for formatter in [pointFormatter, commaFormatter] {
            if let number = formatter.number(from: fromInput) {
                return number.decimalValue
            }
        }
        
        return Decimal(0.0)
    }
    
    init(_ string: String) {
        if let _ = Decimal(string: string) {
            self.init(string: string)!
            return
        }
        
        self.init(string: "0")!
    }
    
    init(_ float: Float) {
        let dec = NSNumber(value: float)
        self = dec.decimalValue
    }
    
    var string: String {
        return String(describing: self)
    }
    
    var double: Double {
        return NSDecimalNumber(decimal:self).doubleValue
    }
    
    var float: Float {
        return NSDecimalNumber(decimal:self).floatValue
    }
    
    var int64: Int64 {
        return NSDecimalNumber(decimal:self).int64Value
    }
    
    var int: Int {
        return NSDecimalNumber(decimal:self).intValue
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
        return currencyFormatter.string(from: NSDecimalNumber(decimal: self)) ?? "0"
    }
    
}
