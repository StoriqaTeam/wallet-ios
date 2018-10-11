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
    func createTransaction() -> Transaction?
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
    
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let accountProvider: AccountsProviderProtocol
    private let feeWaitProvider: PaymentFeeAndWaitProviderProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    
    init(converterFactory: CurrecncyConverterFactoryProtocol,
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
    
    func createTransaction() -> Transaction? {
        //TODO: timestamp?
//        let timestamp = Date()
//        let fiatAmount = currencyConverter.convert(amount: amount, to: .fiat)
//        let transaction = Transaction(currency: selectedAccount.currency,
//                                      direction: .send,
//                                      fiatAmount: fiatAmount,
//                                      cryptoAmount: amount,
//                                      timestamp: timestamp,
//                                      status: .pending,
//                                      opponent: opponentType)
        return nil
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
