//
//  Ratesprovider.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
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
        Rate(fromISO: "STQ", toISO: "USD", value: 0.002247),
        Rate(fromISO: "STQ", toISO: "EUR", value: 0.002002),
        Rate(fromISO: "STQ", toISO: "RUB", value: 0.1468),
        
        Rate(fromISO: "ETH", toISO: "USD", value: 195.68),
        Rate(fromISO: "ETH", toISO: "EUR", value: 173),
        Rate(fromISO: "ETH", toISO: "RUB", value: 13158.01),
        
        Rate(fromISO: "BTC", toISO: "USD", value: 6310.62),
        Rate(fromISO: "BTC", toISO: "EUR", value: 5551.09),
        Rate(fromISO: "BTC", toISO: "RUB", value: 422951.05)
    ]
    
    init(ratesDataStoreService: RatesDataStoreServiceProtocol) {
        self.ratesDataStoreService = ratesDataStoreService
    }
    
    func getRate(criptoISO: String, in fiat: FiatCurrency) -> Rate {
        let rates = currenctRates(for: criptoISO)
        return rates.first(where: { $0.toISO == fiat.rawValue })!
    }
}


// MARK: Private methods

extension RatesProvider {
    private func currenctRates(for criptoISO: String) -> [Rate] {
        var rates = ratesDataStoreService.getRates(cryptoCurrency: criptoISO)
        guard rates.isEmpty else { return rates }
        rates = defaultRates.filter { $0.fromISO == criptoISO }
        guard !rates.isEmpty else { return defaultRates.filter { $0.fromISO == "ETH" } }
        return rates
    }
}
