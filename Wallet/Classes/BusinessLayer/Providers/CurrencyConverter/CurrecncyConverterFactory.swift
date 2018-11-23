//
//  CurrecncyConverterFactory.swift
//  Wallet
//
//  Created by Storiqa on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrencyConverterFactoryProtocol {
    func createConverter(from currency: Currency) -> CurrencyConverterProtocol
}

class CurrencyConverterFactory: CurrencyConverterFactoryProtocol {
    
    private let ratesProvider: RatesProviderProtocol
    
    init(ratesProvider: RatesProviderProtocol) {
        self.ratesProvider = ratesProvider
    }
    
    func createConverter(from currency: Currency) -> CurrencyConverterProtocol {
        switch currency {
        case .btc:
            return BtcConverter(ratesProvider: ratesProvider)
        case .eth:
            return EthConverter(ratesProvider: ratesProvider)
        case .stq:
            return StqConverter(ratesProvider: ratesProvider)
        case .fiat:
            return FiatConverter(ratesProvider: ratesProvider)
        }
    }
    
}
