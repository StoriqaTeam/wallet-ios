//
//  CurrencyFormatter.swift
//  Wallet
//
//  Created by Storiqa on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrencyFormatterProtocol {
    func getStringFrom(amount: Decimal, currency: Currency) -> String
    func getStringFrom(amount: Decimal, currency: Currency, maxFractionDigits: Int) -> String
    func getStringWithoutCurrencyFrom(amount: Decimal, currency: Currency) -> String
}

class CurrencyFormatter: CurrencyFormatterProtocol {
    
    func getStringFrom(amount: Decimal, currency: Currency) -> String {
        let amountStr = getFormatted(amount: amount, currency: currency, usesGroupingSeparator: true)
        
        switch currency {
        case .fiat:
            return currency.symbol + amountStr
        default:
            return amountStr + " " + currency.symbol
        }
    }
    
    func getStringWithoutCurrencyFrom(amount: Decimal, currency: Currency) -> String {
        let amountStr = getFormatted(amount: amount, currency: currency, usesGroupingSeparator: false)
        return amountStr
    }
    
    func getStringFrom(amount: Decimal, currency: Currency, maxFractionDigits: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxFractionDigits
        formatter.usesGroupingSeparator = true
        
        let amountStr = formatter.string(for: amount)!
        switch currency {
        case .fiat:
            return currency.symbol + amountStr
        default:
            return amountStr + " " + currency.symbol
        }
    }
}


// MARK: Private methods

extension CurrencyFormatter {
    private func getFormatted(amount: Decimal, currency: Currency, usesGroupingSeparator: Bool) -> String {
        let fractionDigits: Int
        switch currency {
        case .eth, .stq:
            fractionDigits = 18
        case .btc:
            fractionDigits = 8
        default:
            fractionDigits = 2
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = fractionDigits
        formatter.usesGroupingSeparator = usesGroupingSeparator
        
        let amountStr = formatter.string(for: amount)!
        return amountStr
    }
}
