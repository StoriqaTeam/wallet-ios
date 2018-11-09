//
//  SendTransactionBuilderFactory.swift
//  Wallet
//
//  Created by Tata Gri on 09/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SendTransactionBuilderFactoryProtocol {
    func create() -> SendTransactionBuilder
}

class SendTransactionBuilderFactory: SendTransactionBuilderFactoryProtocol {
    
    private let currencyConverterFactory: CurrencyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let accountsProvider: AccountsProviderProtocol
    private let feeWaitProvider: PaymentFeeAndWaitProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(currencyConverterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountsProvider: AccountsProviderProtocol,
         feeWaitProvider: PaymentFeeAndWaitProviderProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.currencyConverterFactory = currencyConverterFactory
        self.currencyFormatter = currencyFormatter
        self.accountsProvider = accountsProvider
        self.feeWaitProvider = feeWaitProvider
        self.denominationUnitsConverter = denominationUnitsConverter
    }
    
    func create() -> SendTransactionBuilder {
        return SendTransactionBuilder(currencyConverterFactory: currencyConverterFactory,
                                      currencyFormatter: currencyFormatter,
                                      accountsProvider: accountsProvider,
                                      feeWaitProvider: feeWaitProvider,
                                      denominationUnitsConverter: denominationUnitsConverter)
    }
}
