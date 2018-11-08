//
//  SendTransactionBuilder.swift
//  Wallet
//
//  Created by Storiqa on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol QRScannerDelegate: class {
    func didScanAddress(_ address: String)
}

protocol SendTransactionProviderProtocol: class {
    
    var amount: Decimal { get }
    var paymentFee: Decimal { get }
    var opponentType: OpponentType { get }
    var receiverCurrency: Currency { get }
    var selectedAccount: Account { get }

    func getFeeWaitCount() -> Int
    func getFeeAndWait() -> (fee: String, wait: String)
    func getConvertedAmount() -> Decimal
    func getSubtotal() -> Decimal
    func isEnoughFunds() -> Bool
    func createTransaction() -> Transaction
}

class SendTransactionProvider: SendTransactionProviderProtocol {
    
    weak var scanDelegate: QRScannerDelegate?
    
    var selectedAccount: Account
    var amount: Decimal
    var paymentFee: Decimal
    var opponentType: OpponentType
    var receiverCurrency: Currency {
        didSet { updateConverter() }
    }
    
    private let converterFactory: CurrencyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let accountProvider: AccountsProviderProtocol
    private let feeWaitProvider: PaymentFeeAndWaitProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    
    init(converterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountProvider: AccountsProviderProtocol,
         feeWaitProvider: PaymentFeeAndWaitProviderProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        self.accountProvider = accountProvider
        self.feeWaitProvider = feeWaitProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        
        // default build
        self.amount = 0
        self.paymentFee = 0
        self.opponentType = .address(address: "default")
        self.selectedAccount = accountProvider.getAllAccounts().first!
        self.receiverCurrency = .stq
        
        loadPaymentFees()
        updateConverter()
    }
    
    func setPaymentFee(index: Int) {
        paymentFee = feeWaitProvider.getFee(index: index)
    }
    
    func getFeeWaitCount() -> Int {
        return feeWaitProvider.getValuesCount()
    }
    
    func getFeeAndWait() -> (fee: String, wait: String) {
        let wait = feeWaitProvider.getWait(fee: paymentFee)
        let waitStr = wait.description
        let feeStr = currencyFormatter.getStringFrom(amount: paymentFee, currency: selectedAccount.currency)
        return (feeStr, waitStr)
    }
    
    func getConvertedAmount() -> Decimal {
        guard !amount.isZero else { return 0 }
        let currency = selectedAccount.currency
        let converted = currencyConverter.convert(amount: amount, to: currency)
        return converted
    }
    
    func getSubtotal() -> Decimal {
        let converted = getConvertedAmount()
        let sum = converted + paymentFee
        return sum
    }
    
    func isEnoughFunds() -> Bool {
        let currency = selectedAccount.currency
        let converted = currencyConverter.convert(amount: amount, to: currency)
        let sum = converted + paymentFee
        let inMaxUnits = denominationUnitsConverter.amountToMinUnits(sum, currency: currency)
        let available = selectedAccount.balance
        return inMaxUnits.isLessThanOrEqualTo(available)
    }
    
    func createTransaction() -> Transaction {
        let uuid = UUID().uuidString
        let timestamp = Date()
        let fromCurrency = selectedAccount.currency
        let fromAddress = selectedAccount.accountAddress
        let toAddress: String
        let toAccount: TransactionAccount?
        
        switch opponentType {
        case .address(let address):
            toAddress = address
            toAccount = nil
        case .contact(let contact):
            // TODO: contact would know account (но это не точно)
            toAddress = contact.cryptoAddress!
            toAccount = nil
        case .txAccount(let account, let address):
            toAddress = address
            toAccount = account
        }
        
        let converted = currencyConverter.convert(amount: amount, to: fromCurrency)
        let fromValue = denominationUnitsConverter.amountToMinUnits(converted, currency: fromCurrency)
        let toValue = denominationUnitsConverter.amountToMinUnits(amount, currency: receiverCurrency)
        let fee = denominationUnitsConverter.amountToMinUnits(paymentFee, currency: fromCurrency)
   
        let transaction = Transaction(id: uuid,
                                      fromAddress: [fromAddress],
                                      fromAccount: [],
                                      toAddress: toAddress,
                                      toAccount: toAccount,
                                      fromValue: fromValue,
                                      fromCurrency: fromCurrency,
                                      toValue: toValue,
                                      toCurrency: receiverCurrency,
                                      fee: fee,
                                      blockchainId: "",
                                      createdAt: timestamp,
                                      updatedAt: timestamp,
                                      status: .pending)
        return transaction
    }
    
}


// MARK: - Private methods

extension SendTransactionProvider {
    
    private func updateConverter() {
        currencyConverter = converterFactory.createConverter(from: receiverCurrency)
    }
    
    private func loadPaymentFees() {
        feeWaitProvider.updateSelectedForCurrency(selectedAccount.currency)
        paymentFee = feeWaitProvider.getFee(index: 0)
    }
    
}
