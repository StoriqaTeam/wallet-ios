//
//  DenominationUnitsConverter.swift
//  Wallet
//
//  Created by Tata Gri on 30/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol DenominationUnitsConverterProtocol {
    func amountToMaxUnits(_ amount: Decimal, currency: Currency) -> Decimal
    func amountToMinUnits(_ amount: Decimal, currency: Currency) -> Decimal
}

class DenominationUnitsConverter: DenominationUnitsConverterProtocol {
    private let ethUnits = pow(10, 18)
    private let btcUnits = pow(10, 8)
    
    func amountToMaxUnits(_ amount: Decimal, currency: Currency) -> Decimal {
        switch currency {
        case .eth, .stq:
            return amount / ethUnits
        case .btc:
            return amount / btcUnits
        case .fiat:
            return amount
        }
    }
    
    func amountToMinUnits(_ amount: Decimal, currency: Currency) -> Decimal {
        switch currency {
        case .eth, .stq:
            return amount * ethUnits
        case .btc:
            return amount * btcUnits
        case .fiat:
            return amount
        }
    }
}
