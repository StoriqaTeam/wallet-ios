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
        return 11
    }
}

class EthConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        return 890
    }
}

class StqConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        return 33
    }
}

class FiatConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        return 44
    }
}
