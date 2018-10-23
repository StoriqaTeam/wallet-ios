//
//  Currency.swift
//  Wallet
//
//  Created by Tata Gri on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum Currency: String {
    case btc
    case eth
    case stq
    case fiat
    
    var ISO: String {
        switch self {
        case .btc:
            return "BTC"
        case .eth:
            return "ETH"
        case .stq:
            return "STQ"
        case .fiat:
            return getFiatISO()
        }
    }
    
    var symbol: String {
        switch self {
        case .btc:
            return "BTC"
        case .eth:
            return "ETH"
        case .stq:
            return "STQ"
        case .fiat:
            return currencySymbol(ISO: ISO)
        }
    }
    
    init(string: String) {
        switch string.uppercased() {
        case "ETH":
            self = .eth
        case "STQ":
            self = .stq
        case "BTC":
            self = .btc
        default:
            self = .fiat
        }
    }
    
}


// MARK: - Private methods

private extension Currency {
    
    func getFiatISO() -> String {
        let defaults = DefaultsProvider()
        let fiatISO = defaults.fiatISO
        return fiatISO
    }
    
    func currencySymbol(ISO: String) -> String {
        let locale = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == ISO }
        let symbol = locale?.currencySymbol ?? ""
        return symbol
    }
    
}
