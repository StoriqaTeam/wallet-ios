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
    var paymentFee: Decimal? { get }
    
    func getRecepientAccounts() -> [Account]
    func getFeeWaitCount() -> Int
    func getFeeIndex() -> Int
    func getFeeAndWait() -> (fee: Decimal?, wait: String)
    func getSubtotal() -> Decimal
    func isEnoughFunds() -> Bool
    func updateFees()
    func createTransaction() -> Transaction
}


class ExchangeProvider: ExchangeProviderProtocol {
    
    var selectedAccount: Account {
        didSet {
            updateFees()
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
    var paymentFee: Decimal?
    
    private var feeIndex: Int?
    private var recepientAccounts = [Account]()
    
    private let accountsProvider: AccountsProviderProtocol
    private let feeProvider: FeeProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private let converterFactory: CurrencyConverterFactoryProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    
    init(accountsProvider: AccountsProviderProtocol,
         feeProvider: FeeProviderProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.accountsProvider = accountsProvider
        self.feeProvider = feeProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        self.converterFactory = converterFactory
        
        // default build
        self.amount = 0
        self.paymentFee = 0
        self.selectedAccount = accountsProvider.getAllAccounts().first!
        
        updateRecepientAccounts()
        recepientAccount = recepientAccounts.first
        updateFees()
        updateConverter()
    }
    
    func setPaymentFee(index: Int) {
        guard let fee = feeProvider.getFee(index: index) else {
            feeIndex = nil
            paymentFee = nil
            return
        }
        feeIndex = index
        paymentFee = fee
    }
    
    func getRecepientAccounts() -> [Account] {
        return recepientAccounts
    }
    
    func getFeeIndex() -> Int {
        return feeIndex ?? 0
    }
    
    func getFeeWaitCount() -> Int {
        return feeProvider.getValuesCount()
    }
    
    func getFeeAndWait() -> (fee: Decimal?, wait: String) {
        guard let paymentFee = paymentFee else {
            return (nil, "-")
        }
        
        let currency = selectedAccount.currency
        let wait = feeProvider.getWait(fee: paymentFee)
        let fee = denominationUnitsConverter.amountToMaxUnits(paymentFee, currency: currency)
        return (fee, wait)
    }
    
    func getSubtotal() -> Decimal {
        guard !amount.isZero, let paymentFee = paymentFee else {
            return 0
        }
        
        let currency = selectedAccount.currency
        let converted = currencyConverter.convert(amount: amount, to: currency)
        let fee = denominationUnitsConverter.amountToMaxUnits(paymentFee, currency: currency)
        let sum = converted + fee
        return sum
    }
    
    func isEnoughFunds() -> Bool {
        let currency = selectedAccount.currency
        let subtotal = getSubtotal()
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(subtotal, currency: currency)
        let available = selectedAccount.balance
        return inMinUnits.isLessThanOrEqualTo(available)
    }
    
    func updateFees() {
        let currency = selectedAccount.currency
        feeProvider.updateSelected(fromCurrency: currency, toCurrency: currency)
        
        let count = feeProvider.getValuesCount()
        let index: Int = {
            if let feeIndex = feeIndex, count > feeIndex {
                return feeIndex
            } else {
                return count / 2
            }
        }()
        
        feeIndex = index
        paymentFee = feeProvider.getFee(index: index)
    }
    
    func createTransaction() -> Transaction {
        // FIXME: доделать
        fatalError()
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
