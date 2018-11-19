//
//  ExchangeProviderBuilderFactory.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ExchangeProviderBuilderFactoryProtocol {
    func create() -> ExchangeProviderBuilder
}

class ExchangeProviderBuilderFactory: ExchangeProviderBuilderFactoryProtocol {
    private let accountsProvider: AccountsProviderProtocol
    private let feeProvider: FeeProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private let converterFactory: CurrencyConverterFactoryProtocol
    
    init(accountsProvider: AccountsProviderProtocol,
         feeProvider: FeeProviderProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.accountsProvider = accountsProvider
        self.feeProvider = feeProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        self.converterFactory = converterFactory
    }
    
    func create() -> ExchangeProviderBuilder {
        return ExchangeProviderBuilder(accountsProvider: accountsProvider,
                                       feeProvider: feeProvider,
                                       converterFactory: converterFactory,
                                       denominationUnitsConverter: denominationUnitsConverter)
    }
}
