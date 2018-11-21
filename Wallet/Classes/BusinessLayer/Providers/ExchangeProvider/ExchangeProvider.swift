//
//  ExchangeProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ExchangeProviderProtocol: class {
    var selectedAccount: Account { get }
    var recepientAccount: Account? { get }
    var amount: Decimal { get }
    
    func getRecepientAccounts() -> [Account]
    func getSubtotal() -> Decimal
    func isEnoughFunds() -> Bool
    func createTransaction() -> Transaction
}


class ExchangeProvider: ExchangeProviderProtocol {
    
    var selectedAccount: Account {
        didSet {
            updateRecepientAccounts()
            updateRecepientAccount()
        }
    }
    var recepientAccount: Account? {
        didSet {
            updateConverter()
        }
    }
    var amount: Decimal
    
    private var recepientAccounts = [Account]()
    
    private let accountsProvider: AccountsProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private let converterFactory: CurrencyConverterFactoryProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    
    init(accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.accountsProvider = accountsProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        self.converterFactory = converterFactory
        
        // default build
        self.amount = 0
        self.selectedAccount = accountsProvider.getAllAccounts().first!
        
        updateRecepientAccounts()
        recepientAccount = recepientAccounts.first
        updateConverter()
    }
    
    func getRecepientAccounts() -> [Account] {
        return recepientAccounts
    }
    
    func getSubtotal() -> Decimal {
        guard !amount.isZero else {
            return 0
        }
        
        let currency = selectedAccount.currency
        let converted = currencyConverter.convert(amount: amount, to: currency)
        return converted
    }
    
    func isEnoughFunds() -> Bool {
        let currency = selectedAccount.currency
        let subtotal = getSubtotal()
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(subtotal, currency: currency)
        let available = selectedAccount.balance
        return inMinUnits.isLessThanOrEqualTo(available)
    }
    
    func createTransaction() -> Transaction {
        // FIXME: доделать
        fatalError("createTransaction")
    }
    
}


// MARK: Private methods

extension ExchangeProvider {
    
    private func updateRecepientAccounts() {
        let allAccounts = accountsProvider.getAllAccounts()
        let filtered = allAccounts.filter {
            $0.currency != selectedAccount.currency
        }
        recepientAccounts = filtered
    }
    
    private func updateRecepientAccount() {
        if !recepientAccounts.contains(where: { $0 == recepientAccount }) {
            recepientAccount = recepientAccounts.first
        }
    }
    
    private func updateConverter() {
        // In case when there is only one account
        let currency = recepientAccount?.currency ?? selectedAccount.currency
        currencyConverter = converterFactory.createConverter(from: currency)
    }
    
}
