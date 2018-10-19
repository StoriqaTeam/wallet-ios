//
//  CryptoCurrencyConverter.swift
//  Wallet
//
//  Created by user on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal
}

class BtcConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        let coef: Decimal
        
        switch currency {
        case .btc:
            coef = 1
        case .eth:
            coef = 31.92412580
        case .stq:
            coef = 2760872.72401590
        case .fiat:
            coef = 6563.0
        }
        
        return coef * amount
    }
}

class EthConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        let coef: Decimal
        
        switch currency {
        case .btc:
            coef = 0.03132404
        case .eth:
            coef = 1
        case .stq:
            coef = 86504.59914677
        case .fiat:
            coef = 200.0
        }
        
        return coef * amount
    }
}

class StqConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        let coef: Decimal
        
        switch currency {
        case .btc:
            coef = 0.00000036
        case .eth:
            coef = 0.00001156
        case .stq:
            coef = 1
        case .fiat:
            coef = 0.002358
        }
        
        return coef * amount
    }
}

class FiatConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        let coef: Decimal
        
        switch currency {
        case .btc:
            coef = 0.000152
        case .eth:
            coef = 0.0050
        case .stq:
            coef = 424.08821034
        case .fiat:
            coef = 1
        }
        
        return coef * amount
    }
}
