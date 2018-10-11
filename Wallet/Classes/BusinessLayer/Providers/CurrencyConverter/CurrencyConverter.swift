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
        return 11 * amount
    }
}

class EthConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        return 890 * amount
    }
}

class StqConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        return 0.26 * amount
    }
}

class FiatConverter: CurrencyConverterProtocol {
    func convert(amount: Decimal, to currency: Currency) -> Decimal {
        return 44 * amount
    }
}
