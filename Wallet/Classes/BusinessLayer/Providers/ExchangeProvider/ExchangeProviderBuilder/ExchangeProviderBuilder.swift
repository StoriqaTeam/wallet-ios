//
//  ExchangeProviderBuilder.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ExchangeProviderBuilderProtocol: class {
    func set(account: Account)
    func set(recipientAccount: Account)
    func set(cryptoAmount: Decimal)
    func set(order: Order)
    func build() -> ExchangeProvider
    func clear()
}

class ExchangeProviderBuilder: ExchangeProviderBuilderProtocol {

    private var exchangeProvider: ExchangeProvider
    private let accountsProvider: AccountsProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private let converterFactory: CurrencyConverterFactoryProtocol
    private let orderObserver: OrderObserverProtocol
    
    init(accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol,
         orderObserver: OrderObserverProtocol) {
        
        self.accountsProvider = accountsProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        self.converterFactory = converterFactory
        self.orderObserver = orderObserver
        
        exchangeProvider = ExchangeProvider(accountsProvider: accountsProvider,
                                            converterFactory: converterFactory,
                                            denominationUnitsConverter: denominationUnitsConverter,
                                            orderObserver: orderObserver)
    }
    
    func set(account: Account) {
        exchangeProvider.selectedAccount = account
    }
    
    func set(recipientAccount: Account) {
        exchangeProvider.recipientAccount = recipientAccount
    }
    
    func set(cryptoAmount: Decimal) {
        exchangeProvider.amount = cryptoAmount
    }
    
    func set(order: Order) {
        exchangeProvider.setNewOrder(order)
    }
    
    func build() -> ExchangeProvider {
        return exchangeProvider
    }
    
    func clear() {
        exchangeProvider = ExchangeProvider(accountsProvider: accountsProvider,
                                            converterFactory: converterFactory,
                                            denominationUnitsConverter: denominationUnitsConverter,
                                            orderObserver: orderObserver)
    }
}
