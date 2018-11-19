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
    func set(recepientAccount: Account)
    func set(cryptoAmount: Decimal)
    func setPaymentFee(index: Int)
    func build() -> ExchangeProvider
    func clear()
}

class ExchangeProviderBuilder: ExchangeProviderBuilderProtocol {
    
    private var exchangeProvider: ExchangeProvider
    
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
        
        exchangeProvider = ExchangeProvider(accountsProvider: accountsProvider,
                                            feeProvider: feeProvider,
                                            converterFactory: converterFactory,
                                            denominationUnitsConverter: denominationUnitsConverter)
    }
    
    func set(account: Account) {
        exchangeProvider.selectedAccount = account
    }
    
    func set(recepientAccount: Account) {
        exchangeProvider.recepientAccount = recepientAccount
    }
    
    func set(cryptoAmount: Decimal) {
        exchangeProvider.amount = cryptoAmount
    }
    
    func setPaymentFee(index: Int) {
        exchangeProvider.setPaymentFee(index: index)
    }
    
    func build() -> ExchangeProvider {
        return exchangeProvider
    }
    
    func clear() {
        exchangeProvider = ExchangeProvider(accountsProvider: accountsProvider,
                                            feeProvider: feeProvider,
                                            converterFactory: converterFactory,
                                            denominationUnitsConverter: denominationUnitsConverter)
    }
}
