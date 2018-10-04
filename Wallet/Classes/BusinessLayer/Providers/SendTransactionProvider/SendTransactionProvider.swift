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
    
    var amount: Decimal! { get }
    var paymentFee: Decimal { get }
    var opponentType: OpponentType { get }
    var receiverCurrency: Currency { get }
    var selectedAccount: Account { get }

    func getFeeWaitCount() -> Int
    func getFeeAndWait() -> (fee: String, wait: String)
    func getSubtotal() -> String
    func isEnoughFunds() -> Bool
    func createTransaction() -> Transaction
}

class SendTransactionProvider: SendTransactionProviderProtocol {
    
    weak var scanDelegate: QRScannerDelegate?
    
    var selectedAccount: Account
    
    var receiverCurrency: Currency {
        didSet {
            updateConverter()
        }
    }
    
    var amount: Decimal!
    var paymentFee: Decimal
    var opponentType: OpponentType
    
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    private let accountProvider: AccountsProviderProtocol
    
    //FIXME: stub
    private var feeWait: [Decimal: String] = [1: "10",
                                              2: "9",
                                              3: "8",
                                              4: "7",
                                              5: "6",
                                              6: "5"]
    
    init(converterFactory: CurrecncyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountProvider: AccountsProviderProtocol) {
        
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        
        // default build
        self.paymentFee = 0
        self.opponentType = .address(address: "default")
        self.accountProvider = accountProvider
        self.selectedAccount = accountProvider.getAllAccounts().first!
        self.receiverCurrency = .btc
    }
    
    func getAmountInTransactionCurrencyStr() -> String {
        guard let amount = amount, !amount.isZero else {
                return ""
        }
        
        let currency = selectedAccount.currency
        let converted = currencyConverter.convert(amount: amount, to: currency)
        let formatted = currencyFormatter.getStringFrom(amount: converted, currency: currency)
        return "=" + formatted
    }
    
    func getFeeWaitCount() -> Int {
        return feeWait.count
    }
    
    func getFeeAndWait() -> (fee: String, wait: String) {
        let wait = feeWait[paymentFee]! + "s"
        let feeStr = paymentFee.description + " " + selectedAccount.currency.ISO
        return (feeStr, wait)
    }
    
    func getSubtotal() -> String {
        let converted = currencyConverter.convert(amount: amount, to: selectedAccount.currency)
        let sum = converted + paymentFee
        let formatted = currencyFormatter.getStringFrom(amount: sum, currency: selectedAccount.currency)
        
        return formatted
    }
    
    func isEnoughFunds() -> Bool {
        let converted = currencyConverter.convert(amount: amount, to: selectedAccount.currency)
        let sum = converted + paymentFee
        //TODO: amount in decimal
        let available = selectedAccount.cryptoAmount.decimalValue()
        return sum.isLessThanOrEqualTo(available)
    }
    
    func createTransaction() -> Transaction {
        //TODO: timestamp?
        let timestamp = Date()
        let fiatAmount = currencyConverter.convert(amount: amount, to: .fiat)
        let transaction = Transaction(currency: selectedAccount.currency,
                                      direction: .send,
                                      fiatAmount: fiatAmount,
                                      cryptoAmount: amount,
                                      timestamp: timestamp,
                                      status: .pending,
                                      opponent: opponentType)
        return transaction
    }
    
}


// MARK: - Private methods

extension SendTransactionProvider {
    private func updateConverter() {
        currencyConverter = converterFactory.createConverter(from: receiverCurrency)
    }
}
