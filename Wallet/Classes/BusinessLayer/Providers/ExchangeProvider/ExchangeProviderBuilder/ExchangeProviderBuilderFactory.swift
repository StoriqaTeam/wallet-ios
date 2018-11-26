//
//  ExchangeProviderBuilderFactory.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ExchangeProviderBuilderFactoryProtocol {
    func create() -> ExchangeProviderBuilderProtocol
}

class ExchangeProviderBuilderFactory: ExchangeProviderBuilderFactoryProtocol {
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
    }
    
    func create() -> ExchangeProviderBuilderProtocol {
        return ExchangeProviderBuilder(accountsProvider: accountsProvider,
                                       converterFactory: converterFactory,
                                       denominationUnitsConverter: denominationUnitsConverter,
                                       orderObserver: orderObserver)
    }
}
