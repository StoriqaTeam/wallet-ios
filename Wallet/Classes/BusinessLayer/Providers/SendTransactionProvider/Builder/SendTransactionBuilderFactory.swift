//
//  SendTransactionBuilderFactory.swift
//  Wallet
//
//  Created by Storiqa on 09/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SendTransactionBuilderFactoryProtocol {
    func create() -> SendProviderBuilderProtocol
}

class SendTransactionBuilderFactory: SendTransactionBuilderFactoryProtocol {
    
    private let currencyConverterFactory: CurrencyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let accountsProvider: AccountsProviderProtocol
    private let feeProvider: FeeProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(currencyConverterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountsProvider: AccountsProviderProtocol,
         feeProvider: FeeProviderProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.currencyConverterFactory = currencyConverterFactory
        self.currencyFormatter = currencyFormatter
        self.accountsProvider = accountsProvider
        self.feeProvider = feeProvider
        self.denominationUnitsConverter = denominationUnitsConverter
    }
    
    func create() -> SendProviderBuilderProtocol {
        return SendTransactionBuilder(currencyConverterFactory: currencyConverterFactory,
                                      currencyFormatter: currencyFormatter,
                                      accountsProvider: accountsProvider,
                                      feeProvider: feeProvider,
                                      denominationUnitsConverter: denominationUnitsConverter)
    }
}
