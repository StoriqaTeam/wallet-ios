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

protocol SendTransactionBuilderProtocol: class {
    var scanDelegate: QRScannerDelegate? { set get }
    var selectedAccount: Account! { set get }
    var receiverCurrency: Currency! { set get }
    var amount: Decimal! { set get }
    var paymentFee: Decimal! { get }
    var opponentType: OpponentType! { get }
    
    func getReceiverName() -> String
    func getAmountStr() -> String
    func getAmountWithoutCurrencyStr() -> String
    func getAmountInTransactionCurrencyStr() -> String
    func getFeeWaitCount() -> Int
    func getFeeAndWait() -> (fee: String, wait: String)
    func getSubtotal() -> String
    func isEnoughFunds() -> Bool
    func createTransaction() -> Transaction
    
    func setScannedAddress(_ address: String)
    func setContact(_ contact: Contact)
    func setPaymentFee(index: Int)
}

class SendTransactionBuilder: SendTransactionBuilderProtocol {
    weak var scanDelegate: QRScannerDelegate?
    
    var selectedAccount: Account!
    var receiverCurrency: Currency! {
        didSet {
            updateConverter()
        }
    }
    var amount: Decimal!
    var paymentFee: Decimal!
    var opponentType: OpponentType!
    
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    
    //FIXME: stub
    private var feeWait: [Decimal: String] = [1: "10",
                                              2: "9",
                                              3: "8",
                                              4: "7",
                                              5: "6",
                                              6: "5"]
    
    init(converterFactory: CurrecncyConverterFactoryProtocol, currencyFormatter: CurrencyFormatterProtocol) {
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
    }
    
    func getReceiverName() -> String {
        //FIXME: stub
        switch opponentType! {
        case .contact(let contact):
            return contact.name
        default:
            return "Receiver Name"
        }
    }
    
    func getAmountStr() -> String {
        guard let amount = amount, !amount.isZero,
            let receiverCurrency = receiverCurrency else {
                return ""
        }
        
        let formatted = currencyFormatter.getStringFrom(amount: amount, currency: receiverCurrency)
        return formatted
    }
    
    func getAmountWithoutCurrencyStr() -> String {
        guard let amount = amount, !amount.isZero else {
                return ""
        }
        return amount.description
    }
    
    func getAmountInTransactionCurrencyStr() -> String {
        guard let amount = amount, !amount.isZero,
            let currency = selectedAccount?.currency else {
                return ""
        }
        let converted = currencyConverter.convert(amount: amount, to: currency)
        let formatted = currencyFormatter.getStringFrom(amount: converted, currency: currency)
        return "=" + formatted
    }
    
    func getFeeWaitCount() -> Int {
        return feeWait.count
    }
    
    func setScannedAddress(_ address: String) {
        opponentType = OpponentType.address(address: address)
        scanDelegate?.didScanAddress(address)
    }
    
    func setContact(_ contact: Contact) {
        opponentType = OpponentType.contact(contact: contact)
    }
    
    func setPaymentFee(index: Int) {
        let paymentFeeValues: [Decimal] = Array(feeWait.keys).sorted()
        paymentFee = paymentFeeValues[index]
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

extension SendTransactionBuilder {
    private func updateConverter() {
        currencyConverter = converterFactory.createConverter(from: receiverCurrency)
    }
}
