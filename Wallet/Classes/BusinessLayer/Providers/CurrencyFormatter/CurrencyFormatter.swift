//
//  CurrencyFormatter.swift
//  Wallet
//
//  Created by user on 26.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrencyFormatterProtocol {
    
    func getStringFrom(amount: Decimal, currency: Currency) -> String
    
}

class CurrencyFormatter: CurrencyFormatterProtocol {
    
    func getStringFrom(amount: Decimal, currency: Currency) -> String {
        return amount.description + " " + currency.ISO
    }
    
}
