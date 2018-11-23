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
        exchangeProviderBuilder.set(account: account)
    }
    
    deinit {
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
        
        self.expiredOrderChannelInput?.removeObserver(withId: self.objId)
        self.expiredOrderChannelInput = nil
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
}


// MARK: - ExchangeInteractorInput

extension ExchangeInteractor: ExchangeInteractorInput {
    
    func getAccountName() -> String {
        return exchangeProvider.selectedAccount.name
    }
    
    func getRecepientAccountName() -> String {
        return exchangeProvider.recepientAccount?.name ?? ""
    }
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getRecepientAccounts() -> [Account] {
        return exchangeProvider.getRecepientAccounts()
    }
    
    func getAccountIndex() -> Int {
        let account = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: account)
        return index
    }
    
    func getAccountsCount() -> Int {
        return accountsProvider.getAllAccounts().count
    }
    
    func getAmount() -> Decimal {
        return exchangeProvider.amount
    }
    
    func getAccountCurrency() -> Currency {
        let account = exchangeProvider.selectedAccount
        let currency = account.currency
        return currency
    }
    
    func getRecepientCurrency() -> Currency {
        guard let account = exchangeProvider.recepientAccount else {
            return getAccountCurrency()
        }
        
        let currency = account.currency
        return currency
    }
    
    func setCurrentAccount(index: Int) {
        let currentIndex = getAccountIndex()
        guard currentIndex != index else { return }
        
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        let account = allAccounts[index]
        exchangeProviderBuilder.set(account: account)
        
        updateRecepientAccount()
        updateAmount()
        updateTotal()
    }
    
    func setAmount(_ amount: Decimal) {
        exchangeProviderBuilder.set(cryptoAmount: amount)
        
        updateTotal()
    }
    
    func getTransactionBuilder() -> ExchangeProviderBuilderProtocol {
        return exchangeProviderBuilder
    }
    
    func updateState() {
        let account = accountWatcher.getAccount()
        exchangeProviderBuilder.set(account: account)
        
        updateRecepientAccount()
        updateAmount()
        updateTotal()
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
        
        sendTransactionService.sendExchangeTransaction(
            transaction: exchangeTransaction,
            fromAccount: fromAccount,
            exchangeId: orderId,
            exchangeRate: rate) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.exchangeTxSucceed()
                case .failure(let error):
                    if let error = error as? SendTransactionNetworkProviderError {
                        switch error {
                        case .amountOutOfBounds(let min, let max, let currency):
                            self?.output.exchangeTxAmountOutOfLimit(min: min, max: max, currency: currency)
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
        updateRecepientAccount()
        output.updateAccounts(accounts: accounts, index: index)
    }
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account } ?? 0
    }
    
    private func orderDidExpire(_ order: Order?) {
        exchangeProvider.invalidateOrder()
        updateTotal()
        
    }
}


// MARK: - OrderObserverDelegate

extension ExchangeInteractor: OrderObserverDelegate {
    func updateExpired(seconds: Int) {
        let amount = exchangeProvider.amount
        guard !amount.isZero else {
            output.updateOrder(time: nil)
            return
        }
        
        output.updateOrder(time: seconds)
    }
}


// MARK: - Updaters

extension ExchangeInteractor {
    
    private func updateRecepientAccount() {
        let account = exchangeProvider.recepientAccount
        output.updateRecepientAccount(account)
    }
    
    private func updateAmount() {
        guard let recepientAccount = exchangeProvider.recepientAccount else {
            return
        }
        
        let amount = exchangeProvider.amount
        let currency = recepientAccount.currency
        output.updateAmount(amount, currency: currency)
    }
    
    private func updateTotal() {
        let accountCurrency = accountWatcher.getAccount().currency
        let amount = exchangeProvider.getAmountInMinUnits()
        let exchangeAmount: Decimal = amount.isZero ? 1 : 0

        guard let recepientCurrency = exchangeProvider.recepientAccount?.currency else {
            log.error("Recepient account not found")
            output.updateFormIsValid(false)
            output.updateRateFor(oneUnit: nil, from: .fiat, to: .fiat)
            return
        }
        
        let formIsValid = isFormValid()
        let isEnough = exchangeProvider.isEnoughFunds()
        let hasAmount = !exchangeProvider.amount.isZero
        
        exchangeRatesLoader.getExchangeRates(from: accountCurrency,
                                             to: recepientCurrency,
                                             amountCurrency: recepientCurrency,
                                             amountInMinUnits: exchangeAmount) { [weak self]  (result) in
                                                switch result {
                                                case .success(let exchangeRate):
                                                    guard let strongSelf = self else { return }
                                                    
                                                    strongSelf.updateOrder(with: exchangeRate)
                                                    
                                                    let total = strongSelf.exchangeProvider.getSubtotal()
                                                    let formIsValid = strongSelf.isFormValid()
                                                    let isEnough = strongSelf.exchangeProvider.isEnoughFunds()
                                                    let hasAmount = !strongSelf.exchangeProvider.amount.isZero
                                                    
                                                    strongSelf.output.updateTotal(total, currency: accountCurrency)
                                                    strongSelf.output.updateIsEnoughFunds(!hasAmount || isEnough)
                                                    strongSelf.output.updateFormIsValid(formIsValid)
                                                    strongSelf.updateRateForOneUnit(from: accountCurrency, to: recepientCurrency)
                                                    strongSelf.removeTimerIfNeeded(amount: amount)
                                                    
                                                case .failure(let error):
                                                    log.error(error)
                                                    guard let strongSelf = self else { return }
                                                    
                                                    strongSelf.output.updateTotal(0, currency: accountCurrency)
                                                    strongSelf.output.updateIsEnoughFunds(!hasAmount || isEnough)
                                                    strongSelf.output.updateFormIsValid(false)
                                                    strongSelf.output.updateRateFor(oneUnit: nil, from: .fiat, to: .fiat)
                                                }
        }
    }
    
    private func isFormValid() -> Bool {
        let isZeroAmount = exchangeProvider.amount.isZero
        let hasRecepient = exchangeProvider.recepientAccount != nil
        return !isZeroAmount && hasRecepient && exchangeProvider.isEnoughFunds()
    }
    
    
    private func updateOrder(with exchangeRate: ExchangeRate) {
        let order = orderFactory.createOrder(from: exchangeRate)
        exchangeProviderBuilder.set(order: order)
    }
    
    
    private func updateRateForOneUnit(from: Currency, to: Currency) {
        guard let rate = exchangeProvider.getRateForCurrentOrder() else {
            output.updateRateFor(oneUnit: nil, from: .fiat, to: .fiat)
            return
        }
        
        output.updateRateFor(oneUnit: 1/rate, from: to, to: from)
    }
    
    private func removeTimerIfNeeded(amount: Decimal) {
        if amount.isZero {
            output.updateOrder(time: nil)
        }
    }
    
}
