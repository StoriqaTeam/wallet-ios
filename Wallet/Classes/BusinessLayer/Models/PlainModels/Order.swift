//
//  Order.swift
//  Wallet
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


struct Order {
    
    private let exchangeRate: ExchangeRate
    
    private var now: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
    }
}
