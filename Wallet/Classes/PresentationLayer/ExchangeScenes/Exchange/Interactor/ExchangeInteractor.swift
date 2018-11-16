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
    private let converterFactory: CurrencyConverterFactoryProtocol
    private let feeProvider: FeeProviderProtocol
    private var accountsUpadteChannelInput: AccountsUpdateChannel?
    private var currencyConverter: CurrencyConverterProtocol!
    private var recepientAccount: Account? {
        didSet { updateConverter() }
    }
    private var amount: Decimal
    private var paymentFee: Decimal?
    private var recepientAccounts: [Account]!
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         feeProvider: FeeProviderProtocol) {
        self.accountWatcher = accountWatcher
        self.accountsProvider = accountsProvider
        self.converterFactory = converterFactory
        self.feeProvider = feeProvider
        
        // Default values
        amount = 0
        recepientAccounts = updateRecepientAccounts()
        recepientAccount = recepientAccounts.first
        
        loadPaymentFees()
        updateConverter()
    }
    
    deinit {
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
    }
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadteChannelInput = channel
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
        guard let recepientAccount = recepientAccount else {
            // In case when there is only one account
            return getAccountCurrency()
        }
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
        paymentFee = feeProvider.getFee(index: index)
        
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
    
    func startObservers() {
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
    }
    
}


// MARK: - Private methods

extension ExchangeInteractor {
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account } ?? 0
    }
    
    private func updateRecepientAccounts() -> [Account] {
        let allAccounts = accountsProvider.getAllAccounts()
        let filtered = allAccounts.filter {
            $0 != accountWatcher.getAccount()
        }
        return filtered
    }
    
    private func loadPaymentFees() {
        guard let recepientAccount = recepientAccount else {
            return
        }
        
        let currency = accountWatcher.getAccount().currency
        feeProvider.updateSelected(fromCurrency: currency, toCurrency: recepientAccount.currency)
        
        let count = feeProvider.getValuesCount()
        let medium = count / 2
        paymentFee = feeProvider.getFee(index: medium)
    }
    
    private func calculateTotalAmount() -> Decimal {
        guard let paymentFee = paymentFee,
            !amount.isZero else {
                return 0
        }
        
        let accountCurrency = accountWatcher.getAccount().currency
        let converted = currencyConverter.convert(amount: amount, to: accountCurrency)
        let total = converted + paymentFee
        
        return total
    }
    
    private func isEnoughFunds(total: Decimal) -> Bool {
        let available = accountWatcher.getAccount().balance
        let isEnoughFunds = total.isLessThanOrEqualTo(available)
        return isEnoughFunds
    }
    
    private func updateConverter() {
        // In case when there is only one account
        let currency = recepientAccount?.currency ?? getAccountCurrency()
        currencyConverter = converterFactory.createConverter(from: currency)
    }
    
}


// MARK: - Updaters

extension ExchangeInteractor {
    
    private func updateRecepientAccount() {
        if !recepientAccounts.contains(where: { $0 == recepientAccount }) {
            recepientAccount = recepientAccounts.first
        }
        
        output.updateRecepientAccount(recepientAccount)
    }
    
    private func updateAmount() {
        guard let recepientAccount = recepientAccount else {
            return
        }
        
        let currency = recepientAccount.currency
        output.updateAmount(amount, currency: currency)
    }
    
    private func updateConvertedAmount() {
        let account = accountWatcher.getAccount()
        output.convertAmount(amount, to: account.currency)
    }
    
    private func updateFeeAndWait() {
        output.updatePaymentFee(paymentFee)
        
        guard let paymentFee = paymentFee else {
            output.updateMedianWait("-")
            return
        }
        
        let wait = feeProvider.getWait(fee: paymentFee)
        output.updateMedianWait(wait)
    }
    
    private func updateFeeCount() {
        let valuesCount = feeProvider.getValuesCount()
        
        guard valuesCount > 0, let paymentFee = paymentFee else {
            output.updatePaymentFees(count: valuesCount, selected: 0)
            return
        }
        
        let index = feeProvider.getIndex(fee: paymentFee)
        output.updatePaymentFees(count: valuesCount, selected: index)
    }
    
    private func updateTotal() {
        let accountCurrency = accountWatcher.getAccount().currency
        let total = calculateTotalAmount()
        let isEnough = isEnoughFunds(total: total)
        let formIsValid = isEnough && !amount.isZero && recepientAccount != nil
        
        output.updateTotal(total, accountCurrency: accountCurrency)
        output.updateIsEnoughFunds(isEnough)
        output.updateFormIsValid(formIsValid)
    }
    
}


// MARK: - Private methods

extension ExchangeInteractor {
    private func accountsDidUpdate(_ accounts: [Account]) {
        let account = accountWatcher.getAccount()
        let index = accounts.index { $0 == account } ?? 0
        
        accountWatcher.setAccount(accounts[index])
        updateRecepientAccount()
        output.updateAccounts(accounts: accounts, index: index)
    }
}
