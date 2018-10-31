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
    
    private let ratesProvider: RatesProviderProtocol
    
    init(ratesProvider: RatesProviderProtocol) {
        self.ratesProvider = ratesProvider
    }
    
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
            let rate = ratesProvider.getRate(criptoISO: "BTC", in: .USD)
            coef = rate.value
        }
        
        return coef * amount
    }
}

class EthConverter: CurrencyConverterProtocol {
    
    private let ratesProvider: RatesProviderProtocol
    
    init(ratesProvider: RatesProviderProtocol) {
        self.ratesProvider = ratesProvider
    }
    
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
            let rate = ratesProvider.getRate(criptoISO: "ETH", in: .USD)
            coef = rate.value
        }
        
        return coef * amount
    }
}

class StqConverter: CurrencyConverterProtocol {
    
    private let ratesProvider: RatesProviderProtocol
    
    init(ratesProvider: RatesProviderProtocol) {
        self.ratesProvider = ratesProvider
    }
    
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
            let rate = ratesProvider.getRate(criptoISO: "STQ", in: .USD)
            coef = rate.value
        }
        
        return coef * amount
    }
}

class FiatConverter: CurrencyConverterProtocol {

    private let ratesProvider: RatesProviderProtocol
    
    init(ratesProvider: RatesProviderProtocol) {
        self.ratesProvider = ratesProvider
    }
    
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        let coef: Decimal
        let rate = ratesProvider.getRate(criptoISO: currency.ISO, in: .USD)
        
        switch currency {
        case .btc:
            coef = rate.value
        case .eth:
            coef = rate.value
        case .stq:
            coef = rate.value
        case .fiat:
            coef = 1
        }
        
        return amount / coef
    }
}
