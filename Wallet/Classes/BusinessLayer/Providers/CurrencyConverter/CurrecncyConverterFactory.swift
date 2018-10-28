//
//  CurrecncyConverterFactory.swift
//  Wallet
//
//  Created by user on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrencyConverterFactoryProtocol {
    func createConverter(from currency: Currency) -> CurrencyConverterProtocol
}

class CurrencyConverterFactory: CurrencyConverterFactoryProtocol {
    
    func createConverter(from currency: Currency) -> CurrencyConverterProtocol {
        switch currency {
        case .btc:
            return BtcConverter()
        case .eth:
            return EthConverter()
        case .stq:
            return StqConverter()
        case .fiat:
            return FiatConverter()
        }
    }
    
}
