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
    private let exchangeRateNetworkProvider: ExchangeRateNetworkProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let authTokenprovider: AuthTokenProviderProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    
    private var exchangeProvider: ExchangeProviderProtocol
    private var accountsUpadteChannelInput: AccountsUpdateChannel?
    private var feeUpadteChannelInput: FeeUpdateChannel?
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         exchangeProviderBuilder: ExchangeProviderBuilderProtocol,
         sendTransactionService: SendTransactionServiceProtocol,
         exchangeRateNetworkProvider: ExchangeRateNetworkProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         authTokenprovider: AuthTokenProviderProtocol,
         userDataStoreService: UserDataStoreServiceProtocol) {
        
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        self.exchangeProviderBuilder = exchangeProviderBuilder
        self.exchangeProvider = exchangeProviderBuilder.build()
        self.sendTransactionService = sendTransactionService
        self.signHeaderFactory = signHeaderFactory
        self.exchangeRateNetworkProvider = exchangeRateNetworkProvider
        self.authTokenprovider = authTokenprovider
        self.userDataStoreService = userDataStoreService
        
        let account = accountWatcher.getAccount()
        exchangeProviderBuilder.set(account: account)
    }
    
    deinit {
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
        self.feeUpadteChannelInput?.removeObserver(withId: self.objId)
        self.feeUpadteChannelInput = nil
    }
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadteChannelInput = channel
    }
    
    func setFeeUpdateChannelInput(_ channel: FeeUpdateChannel) {
        self.feeUpadteChannelInput = channel
    }
}


// MARK: - ExchangeInteractorInput

extension ExchangeInteractor: ExchangeInteractorInput {
    
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
    
    func getFee() -> Decimal? {
        return exchangeProvider.paymentFee
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
        updateFeeCount()
        updateFeeAndWait()
        updateTotal()
    }
    
    func setAmount(_ amount: Decimal) {
        exchangeProviderBuilder.set(cryptoAmount: amount)
        updateTotal()
    }
    
    func setPaymentFee(index: Int) {
        exchangeProviderBuilder.setPaymentFee(index: index)
        
        updateFeeAndWait()
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
        updateFeeCount()
        updateFeeAndWait()
        updateTotal()
    }
    
    
    func startObservers() {
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
        
        let feeObserver = Observer<[Fee]>(id: self.objId) { [weak self] _ in
            self?.feeDidUpdate()
        }
        self.feeUpadteChannelInput?.addObserver(feeObserver)
    }
    
    func sendTransaction() {
        let txToSend = exchangeProvider.createTransaction()
        let account = exchangeProvider.selectedAccount
        let fromAccount = account.id.lowercased()
        
        sendTransactionService.sendTransaction(
            transaction: txToSend,
            fromAccount: fromAccount) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.exchangeTxSucceed()
                case .failure(let error):
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
    private func feeDidUpdate() {
        exchangeProvider.updateFees()
        
        updateFeeCount()
        updateFeeAndWait()
        updateTotal()
    }
    
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
    
    private func updateFeeAndWait() {
        let feeWait = exchangeProvider.getFeeAndWait()
        output.updatePaymentFee(feeWait.fee)
        output.updateMedianWait(feeWait.wait)
    }
    
    private func updateFeeCount() {
        let count = exchangeProvider.getFeeWaitCount()
        let index = exchangeProvider.getFeeIndex()
        output.updatePaymentFees(count: count, selected: index)
    }
    
    private func updateTotal() {
        let accountCurrency = accountWatcher.getAccount().currency
        let total = exchangeProvider.getSubtotal()
        let formIsValid = isFormValid()
        let isEnough = exchangeProvider.isEnoughFunds()
        let hasAmount = !exchangeProvider.amount.isZero
        
        output.updateTotal(total, currency: accountCurrency)
        output.updateIsEnoughFunds(!hasAmount || isEnough)
        output.updateFormIsValid(formIsValid)
    }
    
    private func isFormValid() -> Bool {
        let isZeroAmount = exchangeProvider.amount.isZero
        let hasRecepient = exchangeProvider.recepientAccount != nil
        let hasFee = exchangeProvider.paymentFee != nil
        
        return !isZeroAmount && hasRecepient && hasFee && exchangeProvider.isEnoughFunds()
    }
    
}
