//
//  SendTransactionBuilder.swift
//  Wallet
//
//  Created by Storiqa on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable function_body_length

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
    private var currencyConverter: CurrencyConverterProtocol!
    
    init(converterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountProvider: AccountsProviderProtocol,
         feeWaitProvider: PaymentFeeAndWaitProviderProtocol) {
        
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        self.accountProvider = accountProvider
        self.feeWaitProvider = feeWaitProvider
        
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
        let waitStr = wait.description + "s"
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
        let converted = currencyConverter.convert(amount: amount, to: selectedAccount.currency)
        let sum = converted + paymentFee
        let available = selectedAccount.balance
        return sum.isLessThanOrEqualTo(available)
    }
    
    func createTransaction() -> Transaction {
        let uuid = UUID().uuidString
        let timestamp = Date()
        let currency = selectedAccount.currency
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
        
        let cryptoAmount: Decimal
        let fee: Decimal
        
        switch currency {
        case .btc:
            cryptoAmount = amount * pow(10, 8)
            fee = paymentFee * pow(10, 8)
        case .eth, .stq:
            cryptoAmount = amount * pow(10, 18)
            fee = paymentFee * pow(10, 18)
        case .fiat:
            cryptoAmount = amount
            fee = paymentFee
        }
        
        let transaction = Transaction(id: uuid,
                                      currency: currency,
                                      fromAddress: [fromAddress],
                                      fromAccount: [],
                                      toAddress: toAddress,
                                      toAccount: toAccount,
                                      cryptoAmount: cryptoAmount,
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
