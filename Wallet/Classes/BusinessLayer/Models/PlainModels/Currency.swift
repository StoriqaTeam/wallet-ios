//
//  Currency.swift
//  Wallet
//
//  Created by Storiqa on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


enum Currency {
    case btc
    case eth
    case stq
    case fiat(ISO: String)
    
    var ISO: String {
        switch self {
        case .btc:
            return "BTC"
        case .eth:
            return "ETH"
        case .stq:
            return "STQ"
        case .fiat(let fiatISO):
            return fiatISO
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
    
    static var defaultFiat: Currency {
        let defaults = DefaultsProvider()
        let fiatISO = defaults.fiatISO
        return Currency.fiat(ISO: fiatISO)
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
            self = .fiat(ISO: string)
        }
    }
    
}

extension Currency: Equatable {
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.ISO == rhs.ISO
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
