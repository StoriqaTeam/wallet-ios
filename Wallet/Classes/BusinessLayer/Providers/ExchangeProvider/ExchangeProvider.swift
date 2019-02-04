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
    var recipientAccount: Account? { get }
    var fromAmount: Decimal { get }
    var toAmount: Decimal { get }
    var mainAmount: ExchangeAmountInput { get }
    
    func setNewOrder(_ order: Order)
    func invalidateOrder()
    func updateAmount()
    
    func getRecipientAccounts() -> [Account]
    func getOrderId() -> String?
    func getFromAmountInMinUnits() -> Decimal
    func getToAmountInMinUnits() -> Decimal
    func getRateForCurrentOrder() -> Decimal?
    func isEnoughFunds() -> Bool
    func createExchangeTransaction() -> Transaction
}

enum ExchangeAmountInput {
    case from
    case to
}

class ExchangeProvider: ExchangeProviderProtocol {
    
    var selectedAccount: Account {
        didSet {
            updateRecipientAccounts()
            updateRecipientAccount()
        }
    }
    var recipientAccount: Account?
    var fromAmount: Decimal
    var toAmount: Decimal
    var mainAmount: ExchangeAmountInput
    
    private var recipientAccounts = [Account]()
    
    private let accountsProvider: AccountsProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private let orderObserver: OrderObserverProtocol
    
    init(accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol,
         orderObserver: OrderObserverProtocol) {
        
        self.accountsProvider = accountsProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        self.orderObserver = orderObserver
        
        // default build
        self.fromAmount = 0
        self.toAmount = 0
        self.selectedAccount = accountsProvider.getAllAccounts().first!
        self.mainAmount = .from

        updateRecipientAccounts()
        recipientAccount = recipientAccounts.first
    }
    
    func invalidateOrder() {
        orderObserver.invalidateOrder()
    }
    
    func setNewOrder(_ order: Order) {
        orderObserver.setNewOrder(order: order)
    }
    
    func updateAmount() {
        guard isValidExchangeRate(),
            let rate = orderObserver.getCurrentRate() else {
                if mainAmount == .from {
                    toAmount = 0
                } else {
                    fromAmount = 0
                }
                return
        }
        
        if mainAmount == .from {
            toAmount = fromAmount * rate
        } else {
            fromAmount = toAmount / rate
        }
    }
    
    func getRecipientAccounts() -> [Account] {
        return recipientAccounts
    }
    
    func getFromAmountInMinUnits() -> Decimal {
        let currency = selectedAccount.currency
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(fromAmount, currency: currency)
        return inMinUnits
    }
    
    func getToAmountInMinUnits() -> Decimal {
        guard let recipientAccount = recipientAccount else {
            return 0
        }
        
        let currency = recipientAccount.currency
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(toAmount, currency: currency)
        return inMinUnits
    }
    
    func isEnoughFunds() -> Bool {
        let currency = selectedAccount.currency
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(fromAmount, currency: currency)
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
        let toAddress = recipientAccount!.accountAddress
        let toAccount = TransactionAccount(accountId: recipientAccount!.id, ownerName: recipientAccount!.name)
        
        let fromValue = denominationUnitsConverter.amountToMinUnits(fromAmount, currency: currency)
        let toValue = denominationUnitsConverter.amountToMinUnits(toAmount, currency: recipientAccount!.currency)
        
        let transaction = Transaction(id: uuid,
                                      fromAddress: [fromAddress],
                                      fromAccount: [],
                                      toAddress: toAddress,
                                      toAccount: toAccount,
                                      fromValue: fromValue, // не используется
            fromCurrency: currency,
            toValue: toValue,
            toCurrency: recipientAccount!.currency,
            fee: 0,
            blockchainIds: [],
            createdAt: timestamp,
            updatedAt: timestamp,
            status: .pending,
            fiatValue: nil,
            fiatCurrency: nil)
        return transaction
    }
    
}


// MARK: Private methods

extension ExchangeProvider {
    
    private func updateRecipientAccounts() {
        let allAccounts = accountsProvider.getAllAccounts()
        let filtered = allAccounts.filter {
            $0.currency != selectedAccount.currency
        }
        recipientAccounts = filtered
    }
    
    private func updateRecipientAccount() {
        if !recipientAccounts.contains(where: { $0 == recipientAccount }) {
            recipientAccount = recipientAccounts.first
        }
    }
    
    private func isValidExchangeRate() -> Bool {
        
        guard let orderCurrencies = orderObserver.getCurrentCurrencies() else { return false }
        
        let from = orderCurrencies.from
        let to = orderCurrencies.to
        
        let selectedFrom = selectedAccount.currency
        guard let selectedTo = recipientAccount?.currency else { return false }
        
        if from == to { return false }
        if selectedTo == to && selectedFrom == from { return true }
        
        return false
    }
}
