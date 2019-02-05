//
//  ExchangeInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


class ExchangeInteractor {
    weak var output: ExchangeInteractorOutput!
    
    private let accountsProvider: AccountsProviderProtocol
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let exchangeProviderBuilder: ExchangeProviderBuilderProtocol
    private let sendTransactionService: SendTransactionServiceProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let authTokenprovider: AuthTokenProviderProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    private let exchangeRatesLoader: ExchangeRatesLoaderProtocol
    private let orderFactory: OrderFactoryProtocol
    
    private var exchangeProvider: ExchangeProviderProtocol
    private var accountsUpadteChannelInput: AccountsUpdateChannel?
    private var expiredOrderChannelInput: OrderExpiredChannel?
    private var orderTickChannelInput: OrderTickChannel?
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         exchangeProviderBuilder: ExchangeProviderBuilderProtocol,
         sendTransactionService: SendTransactionServiceProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         authTokenprovider: AuthTokenProviderProtocol,
         userDataStoreService: UserDataStoreServiceProtocol,
         exchangeRatesLoader: ExchangeRatesLoaderProtocol,
         orderFactory: OrderFactoryProtocol,
         orderObserver: OrderObserverProtocol) {
        
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        self.exchangeProviderBuilder = exchangeProviderBuilder
        self.exchangeProvider = exchangeProviderBuilder.build()
        self.sendTransactionService = sendTransactionService
        self.signHeaderFactory = signHeaderFactory
        self.authTokenprovider = authTokenprovider
        self.userDataStoreService = userDataStoreService
        self.exchangeRatesLoader = exchangeRatesLoader
        self.orderFactory = orderFactory
        
        let account = accountWatcher.getAccount()
        exchangeProviderBuilder.set(fromAccount: account)
    }
    
    deinit {
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
        
        self.expiredOrderChannelInput?.removeObserver(withId: self.objId)
        self.expiredOrderChannelInput = nil
        
        self.orderTickChannelInput?.removeObserver(withId: self.objId) 
        self.orderTickChannelInput = nil
    }
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadteChannelInput = channel
    }
    
    func setOrderExpiredChannelInput(_ channel: OrderExpiredChannel) {
        self.expiredOrderChannelInput = channel
    }
    
    func setOrderTickChannelInput(_ channel: OrderTickChannel) {
        self.orderTickChannelInput = channel
    }
}


// MARK: - ExchangeInteractorInput

extension ExchangeInteractor: ExchangeInteractorInput {
    
    func getFromAccountName() -> String {
        return exchangeProvider.selectedAccount.name
    }
    
    func getToAccountName() -> String {
        return exchangeProvider.recipientAccount?.name ?? ""
    }
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getRecipientAccounts() -> [Account] {
        return exchangeProvider.getRecipientAccounts()
    }
    
    func getAccountIndex() -> Int {
        let account = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: account)
        return index
    }
    
    func getFromAmount() -> Decimal {
        return exchangeProvider.fromAmount
    }
    
    func getToAmount() -> Decimal {
        return exchangeProvider.toAmount
    }
    
    func getFromCurrency() -> Currency {
        let account = exchangeProvider.selectedAccount
        let currency = account.currency
        return currency
    }
    
    func getToCurrency() -> Currency {
        guard let account = exchangeProvider.recipientAccount else {
            return getFromCurrency()
        }
        
        let currency = account.currency
        return currency
    }
    
    func setFromAccount(index: Int) {
        let currentIndex = getAccountIndex()
        guard currentIndex != index else { return }
        
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        let account = allAccounts[index]
        exchangeProviderBuilder.set(fromAccount: account)
        
        updateRecipientAccount()
        updateFromAmount()
        updateToAmount()
        updateValidity()
        updateRate()
    }
    
    
    func setToAccount(index: Int) {
        let recepientAccounts = exchangeProvider.getRecipientAccounts()
        guard recepientAccounts.count > index else { return }
        let selected = recepientAccounts[index]
        exchangeProviderBuilder.set(toAccount: selected)
        
        updateFromAmount()
        updateToAmount()
        updateValidity()
        updateRate()
    }
    
    func setFromAmount(_ amount: Decimal) {
        exchangeProviderBuilder.set(fromAmount: amount)
        exchangeProvider.updateAmount()
        updateToAmount()
        updateValidity()
        updateRate()
    }
    
    func setToAmount(_ amount: Decimal) {
        exchangeProviderBuilder.set(toAmount: amount)
        exchangeProvider.updateAmount()
        updateFromAmount()
        updateValidity()
        updateRate()
    }
    
    func getTransactionBuilder() -> ExchangeProviderBuilderProtocol {
        return exchangeProviderBuilder
    }
    
    func updateState() {
        let account = accountWatcher.getAccount()
        exchangeProviderBuilder.set(fromAccount: account)
        
        updateRecipientAccount()
        updateFromAmount()
        updateToAmount()
        updateValidity()
        updateRate()
    }
    
    func startObservers() {
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
        
        let expiredOrderObserver = Observer<Order?>(id: self.objId) { [weak self] (order) in
            self?.orderDidExpire(order)
        }
        self.expiredOrderChannelInput?.addObserver(expiredOrderObserver)
        
        let orderTickObserver = Observer<Int>(id: self.objId) { [weak self] (seconds) in
            self?.orderTick(seconds)
        }
        self.orderTickChannelInput?.addObserver(orderTickObserver)
        
    }
    
    func sendTransaction() {
        guard let orderId = exchangeProvider.getOrderId() else {
            log.error("Fail to get exchange id")
            return
        }
        
        guard let rate = exchangeProvider.getRateForCurrentOrder() else {
            log.error("Fail to get rate for exchange rate")
            return
        }
        
        let exchangeTransaction = exchangeProvider.createExchangeTransaction()
        let account = exchangeProvider.selectedAccount
        let fromAccount = account.id.lowercased()
        let value = exchangeProvider.mainAmount == .from ? exchangeTransaction.fromValue : exchangeTransaction.toValue
        let currency = exchangeProvider.mainAmount == .from ? exchangeTransaction.fromCurrency : exchangeTransaction.toCurrency
        
        sendTransactionService.sendExchangeTransaction(
            transaction: exchangeTransaction,
            fromAccount: fromAccount,
            value: value,
            currency: currency,
            exchangeId: orderId,
            exchangeRate: rate) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.exchangeTxSucceed()
                case .failure(let error):
                    if let error = error as? SendNetworkError {
                        switch error {
                        case .amountOutOfBounds(let min, let max, let currency):
                            self?.output.exchangeTxAmountOutOfLimit(min: min, max: max, currency: currency)
                            return
                        case .exceededDayLimit(let limit, let currency):
                            self?.output.exceededDayLimit(limit: limit, currency: currency)
                            return
                        default: break
                        }
                    }
                    
                    self?.output.exchangeTxFailed(message: error.localizedDescription)
                }
        }
    }
    
    func clearBuilder() {
        exchangeProviderBuilder.clear()
        exchangeProvider = exchangeProviderBuilder.build()
    }
}


// MARK: - Private methods

extension ExchangeInteractor {
    private func accountsDidUpdate(_ accounts: [Account]) {
        let account = accountWatcher.getAccount()
        let index = accounts.index { $0 == account } ?? 0
        
        accountWatcher.setAccount(accounts[index])
        output.updateFromAccounts(accounts, index: index)
        updateRecipientAccount()
    }
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account } ?? 0
    }
    
    private func orderDidExpire(_ order: Order?) {
        exchangeProvider.invalidateOrder()
        updateValidity()
        updateRate()
    }
    
    private func orderTick(_ seconds: Int) {
        let amount = exchangeProvider.fromAmount
        guard !amount.isZero else {
            output.updateOrder(time: nil)
            return
        }
        
        output.updateOrder(time: seconds)
    }
}


// MARK: - Updaters

extension ExchangeInteractor {
    
    private func updateRecipientAccount() {
        let toAccounts = exchangeProvider.getRecipientAccounts()
        
        guard !toAccounts.isEmpty,
            let selected = exchangeProvider.recipientAccount,
            let index = toAccounts.firstIndex(where: { $0 == selected }) else {
                return
        }
        
        output.updateToAccounts(toAccounts, index: index)
    }
    
    private func updateFromAmount() {
        let selectedAccount = exchangeProvider.selectedAccount
        let amount = exchangeProvider.fromAmount
        let currency = selectedAccount.currency
        output.updateFromAmount(amount, currency: currency)
    }
    
    private func updateToAmount() {
        guard let recipientAccount = exchangeProvider.recipientAccount else {
            return
        }
        
        let amount = exchangeProvider.toAmount
        let currency = recipientAccount.currency
        output.updateToAmount(amount, currency: currency)
    }
    
    private func updateValidity(invalid: Bool = false) {
        let isEnough = exchangeProvider.isEnoughFunds()
        let hasAmount = !exchangeProvider.fromAmount.isZero
        let hasRecipient = exchangeProvider.recipientAccount != nil
        let formIsValid = !invalid && hasAmount && hasRecipient && isEnough
        
        output.updateIsEnoughFunds(!hasAmount || isEnough)
        output.updateFormIsValid(formIsValid)
    }
    
    private func updateRate() {
        let isFromChanged = exchangeProvider.mainAmount == .from
        let fromCurrency = accountWatcher.getAccount().currency
        
        guard let toCurrency = exchangeProvider.recipientAccount?.currency else {
            log.error("Recipient account not found")
            output.updateFormIsValid(false)
            output.updateEmptyRate()
            return
        }
        
        let amount = isFromChanged ? exchangeProvider.getFromAmountInMinUnits() : exchangeProvider.getToAmountInMinUnits()
        let amountCurrency = isFromChanged ? fromCurrency : toCurrency
        let exchangeAmount = max(1, amount)
        
        exchangeRatesLoader.getExchangeRates(
            from: fromCurrency,
            to: toCurrency,
            amountCurrency: amountCurrency,
            amountInMinUnits: exchangeAmount) { [weak self]  (result) in
                switch result {
                case .success(let exchangeRate):
                    guard let strongSelf = self else { return }
                    
                    strongSelf.updateOrder(with: exchangeRate)
                    strongSelf.exchangeProvider.updateAmount()
                    
                    if isFromChanged {
                        let updatedAmount = strongSelf.exchangeProvider.toAmount
                        strongSelf.output.updateToAmount(updatedAmount, currency: toCurrency)
                    } else {
                        let updatedAmount = strongSelf.exchangeProvider.fromAmount
                        strongSelf.output.updateFromAmount(updatedAmount, currency: fromCurrency)
                    }
                    
                    strongSelf.updateValidity()
                    strongSelf.updateRateForOneUnit(from: fromCurrency, to: toCurrency)
                    strongSelf.removeTimerIfNeeded(amount: amount)
                    
                case .failure(let error):
                    log.error(error)
                    guard let strongSelf = self else { return }
                    
                    strongSelf.updateValidity(invalid: false)
                    strongSelf.output.updateOrder(time: nil)
                    strongSelf.output.exchangeRateError(error)
                    strongSelf.output.updateEmptyRate()
                }
        }
    }
    
    private func updateOrder(with exchangeRate: ExchangeRate) {
        let order = orderFactory.createOrder(from: exchangeRate)
        exchangeProviderBuilder.set(order: order)
    }
    
    
    private func updateRateForOneUnit(from: Currency, to: Currency) {
        guard let rate = exchangeProvider.getRateForCurrentOrder() else {
            output.updateEmptyRate()
            return
        }
        
        output.updateRateFor(oneUnit: 1/rate, fromCurrency: to, toCurrency: from)
    }
    
    private func removeTimerIfNeeded(amount: Decimal) {
        if amount.isZero {
            output.updateOrder(time: nil)
        }
    }
    
}
