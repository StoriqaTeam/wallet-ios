//
//  Ratesprovider.swift
//  Wallet
//
//  Created by Даниил Мирошниченко on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//  swiftlint:disable switch_case_alignment

import Foundation

enum FiatCurrency: String {
    case USD
    case RUB
    case EUR
    
    init(isoString: String) {
        switch isoString {
            case "USD": self = .USD
            case "RUB": self = .RUB
            case "EUR": self = .EUR
            default: self = .USD
        }
    }
}


protocol RatesProviderProtocol {
    func getRate(criptoISO: String, in fiat: FiatCurrency) -> Rate
}


class RatesProvider: RatesProviderProtocol {
    private let ratesDataStoreService: RatesDataStoreServiceProtocol
    
    let defaultRates = [
        Rate(criptoISO: "STQ", toFiatISO: "USD", fiatValue: 0.002247),
        Rate(criptoISO: "STQ", toFiatISO: "EUR", fiatValue: 0.002002),
        Rate(criptoISO: "STQ", toFiatISO: "RUB", fiatValue: 0.1468),
        
        Rate(criptoISO: "ETH", toFiatISO: "USD", fiatValue: 195.68),
        Rate(criptoISO: "ETH", toFiatISO: "EUR", fiatValue: 173),
        Rate(criptoISO: "ETH", toFiatISO: "RUB", fiatValue: 13158.01),
        
        Rate(criptoISO: "BTC", toFiatISO: "USD", fiatValue: 6310.62),
        Rate(criptoISO: "BTC", toFiatISO: "EUR", fiatValue: 5551.09),
        Rate(criptoISO: "BTC", toFiatISO: "RUB", fiatValue: 422951.05)
    ]
    
    init(ratesDataStoreService: RatesDataStoreServiceProtocol) {
        self.ratesDataStoreService = ratesDataStoreService
    }
    
    func getRate(criptoISO: String, in fiat: FiatCurrency) -> Rate {
        let rates = currenctRates(for: criptoISO)
        return rates.first(where: { $0.toFiatISO == fiat.rawValue })!
    }
}


// MARK: Private methods

extension RatesProvider {
    private func currenctRates(for criptoISO: String) -> [Rate] {
        var rates = ratesDataStoreService.getRates(cryptoCurrency: criptoISO)
        guard rates.isEmpty else { return rates }
        rates = defaultRates.filter { $0.criptoISO == criptoISO }
        guard !rates.isEmpty else { return defaultRates.filter { $0.criptoISO == "ETH" } }
        return rates
    }
}
