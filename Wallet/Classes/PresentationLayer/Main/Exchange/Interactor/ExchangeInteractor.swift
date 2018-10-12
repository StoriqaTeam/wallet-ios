//
//  ExchangeInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ExchangeInteractor {
    weak var output: ExchangeInteractorOutput!
    
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let accountsProvider: AccountsProviderProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let feeWaitProvider: PaymentFeeAndWaitProviderProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    private var recepientAccount: Account! {
        didSet { updateConverter() }
    }
    private var amount: Decimal
    private var paymentFee: Decimal
    private var recepientAccounts: [Account]!
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol,
         feeWaitProvider: PaymentFeeAndWaitProviderProtocol) {
        self.accountWatcher = accountWatcher
        self.accountsProvider = accountsProvider
        self.converterFactory = converterFactory
        self.feeWaitProvider = feeWaitProvider
        
        // Default values
        amount = 0
        paymentFee = 0
        recepientAccounts = updateRecepientAccounts()
        recepientAccount = recepientAccounts.first!
        
        loadPaymentFees()
        updateConverter()
    }
}


// MARK: - ExchangeInteractorInput

extension ExchangeInteractor: ExchangeInteractorInput {
    
    func getAccountsCount() -> Int {
        return accountsProvider.getAllAccounts().count
    }
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getAccountIndex() -> Int {
        let account = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: account)
        return index
    }
    
    func getRecepientAccounts() -> [Account] {
        return recepientAccounts
    }
    
    func getAmount() -> Decimal {
        return amount
    }
    
    func getAccountCurrency() -> Currency {
        return accountWatcher.getAccount().currency
    }
    
    func getRecepientCurrency() -> Currency {
        return recepientAccount.currency
    }
    
    func setCurrentAccount(index: Int) {
        let currentIndex = getAccountIndex()
        guard currentIndex != index else { return }
        
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        recepientAccounts = updateRecepientAccounts()
        loadPaymentFees()
        updateFeeCount()
        updateRecepientAccount()
        updateConvertedAmount()
        updateFeeAndWait()
        updateTotal()
    }
    
    func setRecepientAccount(index: Int) {
        recepientAccount = recepientAccounts[index]
        
        updateRecepientAccount()
        updateAmount()
        updateConvertedAmount()
        updateTotal()
    }
    
    func setAmount(_ amount: Decimal) {
        self.amount = amount
        
        updateConvertedAmount()
        updateTotal()
    }
    
    func setPaymentFee(index: Int) {
        paymentFee = feeWaitProvider.getFee(index: index)
        
        updateFeeAndWait()
        updateTotal()
    }
    
    func updateInitialState() {
        updateRecepientAccount()
        updateAmount()
        updateConvertedAmount()
        updateFeeCount()
        updateFeeAndWait()
        updateTotal()
    }
    
}


// MARK: - Private methods

extension ExchangeInteractor {
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account }!
    }
    
    private func updateRecepientAccounts() -> [Account] {
        let allAccounts = accountsProvider.getAllAccounts()
        let filtered = allAccounts.filter({
            $0 != accountWatcher.getAccount()
        })
        return filtered
    }
    
    private func loadPaymentFees() {
        let currency = accountWatcher.getAccount().currency
        feeWaitProvider.updateSelectedForCurrency(currency)
        
        let count = feeWaitProvider.getValuesCount()
        let medium = count / 2
        paymentFee = feeWaitProvider.getFee(index: medium)
    }
    
    private func calculateTotalAmount() -> Decimal {
        let accountCurrency = accountWatcher.getAccount().currency
        let total: Decimal
        
        if !amount.isZero {
            let converted = currencyConverter.convert(amount: amount, to: accountCurrency)
            total = converted + paymentFee
        } else {
            total = 0
        }
        
        return total
    }
    
    private func isEnoughFunds(total: Decimal) -> Bool {
        let available = accountWatcher.getAccount().balance
        let isEnoughFunds = total.isLessThanOrEqualTo(available)
        return isEnoughFunds
    }
    
    private func updateConverter() {
        let currency = recepientAccount.currency
        currencyConverter = converterFactory.createConverter(from: currency)
    }
    
}


// MARK: - Updaters

extension ExchangeInteractor {
    
    private func updateRecepientAccount() {
        if !recepientAccounts.contains(where: { $0 == recepientAccount }) {
            recepientAccount = recepientAccounts.first!
        }
        
        output.updateRecepientAccount(recepientAccount)
    }
    
    private func updateAmount() {
        let currency = recepientAccount.currency
        output.updateAmount(amount, currency: currency)
    }
    
    private func updateConvertedAmount() {
        let account = accountWatcher.getAccount()
        output.convertAmount(amount, to: account.currency)
    }
    
    private func updateFeeAndWait() {
        let wait = feeWaitProvider.getWait(fee: paymentFee)
        
        output.updatePaymentFee(paymentFee)
        output.updateMedianWait(wait)
    }
    
    private func updateFeeCount() {
        let count = feeWaitProvider.getValuesCount()
        let index = feeWaitProvider.getIndex(fee: paymentFee)
        output.updatePaymentFees(count: count, selected: index)
    }
    
    private func updateTotal() {
        let accountCurrency = accountWatcher.getAccount().currency
        let total = calculateTotalAmount()
        let isEnough = isEnoughFunds(total: total)
        let formIsValid = isEnough && !amount.isZero
        
        output.updateTotal(total, accountCurrency: accountCurrency)
        output.updateIsEnoughFunds(isEnough)
        output.updateFormIsValid(formIsValid)
    }
    
}
