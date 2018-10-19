//
//  CurrencyFormatter.swift
//  Wallet
//
//  Created by user on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrencyFormatterProtocol {
    func getStringFrom(amount: Decimal, currency: Currency) -> String
    func getStringFrom(amount: Decimal, currency: Currency, fractionDigits: Int) -> String
}

class CurrencyFormatter: CurrencyFormatterProtocol {
    
    func getStringFrom(amount: Decimal, currency: Currency) -> String {
        return getStringFrom(amount: amount, currency: currency, fractionDigits: 8)
    }
    
    func getStringFrom(amount: Decimal, currency: Currency, fractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = fractionDigits
        
        let amountStr = formatter.string(from: NSNumber(value: amount.double))!
        
        switch currency {
        case .fiat:
            return currency.symbol + amountStr
        default:
            return amountStr + " " + currency.symbol
        }
    }
    
}
