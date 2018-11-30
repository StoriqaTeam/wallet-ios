//
//  ExchangeProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable identifier_name

import Foundation


protocol ExchangeProviderProtocol: class {
    var selectedAccount: Account { get }
    var recepientAccount: Account? { get }
    var amount: Decimal { get }
    
    func setNewOrder(_ order: Order)
    func invalidateOrder()
    
    func getRecepientAccounts() -> [Account]
    func getOrderId() -> String?
    func getSubtotal() -> Decimal
    func getAmountInMinUnits() -> Decimal
    func getRateForCurrentOrder() -> Decimal?
    func isEnoughFunds() -> Bool
    func createExchangeTransaction() -> Transaction
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
    private var amountToSend: Decimal = 0
    
    private let accountsProvider: AccountsProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private let converterFactory: CurrencyConverterFactoryProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    private let orderObserver: OrderObserverProtocol
    
    init(accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol,
         orderObserver: OrderObserverProtocol) {
        
        self.accountsProvider = accountsProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        self.converterFactory = converterFactory
        self.orderObserver = orderObserver
        
        // default build
        self.amount = 0
        self.selectedAccount = accountsProvider.getAllAccounts().first!

        updateRecepientAccounts()
        recepientAccount = recepientAccounts.first
        updateConverter()
    }
    
    func invalidateOrder() {
        orderObserver.invalidateOrder()
    }
    
    func setNewOrder(_ order: Order) {
        orderObserver.setNewOrder(order: order)
    }
    
    func getRecepientAccounts() -> [Account] {
        return recepientAccounts
    }
    
    func getSubtotal() -> Decimal {
        guard !amount.isZero else { return 0 }
        guard isValidExchangeRate() else { return 0 }
        guard let rate = orderObserver.getCurrentRate() else { return 0 }
        amountToSend = amount / rate
        return amountToSend
    }
    
    func getAmountInMinUnits() -> Decimal {
        guard let recepientAccount = recepientAccount else {
            return 0
        }
        
        let currency = recepientAccount.currency
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(amount, currency: currency)
        return inMinUnits
    }
    
    func isEnoughFunds() -> Bool {
        let currency = selectedAccount.currency
        let subtotal = getSubtotal()
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(subtotal, currency: currency)
        let available = selectedAccount.balance
        return inMinUnits.isLessThanOrEqualTo(available)
    }
    
    func getRateForCurrentOrder() -> Decimal? {
        guard let rate = orderObserver.getCurrentRate() else { return nil }
        return rate
    }
    
    func getOrderId() -> String? {
        return orderObserver.getCurrentOrderId()
    }
    
    func createExchangeTransaction() -> Transaction {
        
        let uuid = UUID().uuidString
        let timestamp = Date()
        let currency = selectedAccount.currency
        let fromAddress = selectedAccount.accountAddress
        let toAddress = recepientAccount!.accountAddress
        let toAccount = TransactionAccount(accountId: recepientAccount!.id, ownerName: recepientAccount!.name)
        
        let toValue = denominationUnitsConverter.amountToMinUnits(amount, currency: recepientAccount!.currency)
        
        let transaction = Transaction(id: uuid,
                                      fromAddress: [fromAddress],
                                      fromAccount: [],
                                      toAddress: toAddress,
                                      toAccount: toAccount,
                                      fromValue: 0, // не используется
            fromCurrency: currency,
            toValue: toValue,
            toCurrency: recepientAccount!.currency,
            fee: 0,
            blockchainIds: [],
            createdAt: timestamp,
            updatedAt: timestamp,
            status: .pending)
        return transaction
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
    
    private func isValidExchangeRate() -> Bool {
        
        guard let orderCurrencies = orderObserver.getCurrentCurrencies() else { return false }
        
        let from = orderCurrencies.from
        let to = orderCurrencies.to
        
        let selectedFrom = selectedAccount.currency
        guard let selectedTo = recepientAccount?.currency else { return false }
        
        if from == to { return false }
        if selectedTo == to && selectedFrom == from { return true }
        
        return false
    }
}
