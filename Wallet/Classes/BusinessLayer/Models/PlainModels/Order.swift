//
//  Order.swift
//  Wallet
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol OrderProtocol {
    func elapsedTime() -> Int
    func getOrderRateValue() -> Decimal
    func getOrderCurrencies() -> OrderCurrencies
    func getOrderId() -> String
}

typealias OrderCurrencies = (from: Currency, to: Currency)

struct Order: OrderProtocol {
    
    private let exchangeRate: ExchangeRate
    private var now: Int {
        return Int(Date().timeIntervalSince1970)
    }
    
    init(exchangeRate: ExchangeRate) {
        self.exchangeRate = exchangeRate
    }
    
    
    // MARK: - OrderProtocol
    
    func elapsedTime() -> Int {
        let expirationTimeStamp = Int(exchangeRate.expiration.timeIntervalSince1970) - 291
        let elapsedTime = expirationTimeStamp - now
        return elapsedTime <= 0 ? 0 : elapsedTime
    }
    
    func getOrderRateValue() -> Decimal {
        return exchangeRate.rate
    }
    
    func getOrderId() -> String {
        return exchangeRate.id
    }
    
    func getOrderCurrencies() -> OrderCurrencies {
        let from = exchangeRate.from
        let to = exchangeRate.to
        return (from, to)
    }
}
