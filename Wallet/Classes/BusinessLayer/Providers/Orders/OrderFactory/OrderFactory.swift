//
//  OrderFactory.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol OrderFactoryProtocol {
    func createOrder(from exchangeRate: ExchangeRate) -> Order
}


class OrderFactory: OrderFactoryProtocol {
    
    func createOrder(from exchangeRate: ExchangeRate) -> Order {
        return Order(exchangeRate: exchangeRate)
    }
}
