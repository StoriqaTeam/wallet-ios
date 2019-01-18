//
//  Ratesprovider.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RatesProviderProtocol {
    func getRate(cripto: Currency, in fiat: Currency) -> Rate
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
    
    func getRate(cripto: Currency, in fiat: Currency) -> Rate {
        let rates = currentRates(for: cripto.ISO)
        return rates.first(where: { $0.toISO == fiat.ISO })!
    }
}


// MARK: Private methods

extension RatesProvider {
    private func currentRates(for criptoISO: String) -> [Rate] {
        var rates = ratesDataStoreService.getRates(cryptoCurrency: criptoISO)
        guard rates.isEmpty else { return rates }
        rates = defaultRates.filter { $0.fromISO == criptoISO }
        guard !rates.isEmpty else { return defaultRates.filter { $0.fromISO == "ETH" } }
        return rates
    }
}
