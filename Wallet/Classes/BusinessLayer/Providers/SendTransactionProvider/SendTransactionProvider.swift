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
    var receiverAddress: String { get }
    var selectedAccount: Account { get }

    func getFeeWaitCount() -> Int
    func getFeeIndex() -> Int
    func getFeeAndWait() -> (fee: Decimal, wait: String)
    func getSubtotal() -> Decimal
    func isEnoughFunds() -> Bool
    func createTransaction() -> Transaction
}

class SendTransactionProvider: SendTransactionProviderProtocol {
    
    weak var scanDelegate: QRScannerDelegate?
    
    var selectedAccount: Account {
        didSet {
            loadPaymentFees()
        }
    }
    var amount: Decimal
    var paymentFee: Decimal
    var receiverAddress: String
    
    private let accountProvider: AccountsProviderProtocol
    private let feeWaitProvider: PaymentFeeAndWaitProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(accountProvider: AccountsProviderProtocol,
         feeWaitProvider: PaymentFeeAndWaitProviderProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.accountProvider = accountProvider
        self.feeWaitProvider = feeWaitProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        
        // default build
        self.amount = 0
        self.paymentFee = 0
        self.receiverAddress = ""
        self.selectedAccount = accountProvider.getAllAccounts().first!
        
        loadPaymentFees()
    }
    
    func setPaymentFee(index: Int) {
        paymentFee = feeWaitProvider.getFee(index: index)
    }
    
    func getFeeIndex() -> Int {
        return feeWaitProvider.getIndex(fee: paymentFee)
    }
    
    func getFeeWaitCount() -> Int {
        return feeWaitProvider.getValuesCount()
    }
    
    func getFeeAndWait() -> (fee: Decimal, wait: String) {
        let wait = feeWaitProvider.getWait(fee: paymentFee)
        return (paymentFee, wait)
    }
    
    func getSubtotal() -> Decimal {
        guard !amount.isZero else {
            return amount
        }
        
        let sum = amount + paymentFee
        return sum
    }
    
    func isEnoughFunds() -> Bool {
        let currency = selectedAccount.currency
        let sum = amount + paymentFee
        let inMaxUnits = denominationUnitsConverter.amountToMinUnits(sum, currency: currency)
        let available = selectedAccount.balance
        return inMaxUnits.isLessThanOrEqualTo(available)
    }
    
    func createTransaction() -> Transaction {
        let uuid = UUID().uuidString
        let timestamp = Date()
        let currency = selectedAccount.currency
        let fromAddress = selectedAccount.accountAddress
        let toAddress = receiverAddress
        
        let toValue = denominationUnitsConverter.amountToMinUnits(amount, currency: currency)
        let fee = denominationUnitsConverter.amountToMinUnits(paymentFee, currency: currency)
   
        let transaction = Transaction(id: uuid,
                                      fromAddress: [fromAddress],
                                      fromAccount: [],
                                      toAddress: toAddress,
                                      toAccount: nil,
                                      fromValue: 0, // не используется
                                      fromCurrency: currency,
                                      toValue: toValue,
                                      toCurrency: currency,
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
    
    private func loadPaymentFees() {
        let currency = selectedAccount.currency
        feeWaitProvider.updateSelectedForCurrency(currency)
        
        let count = feeWaitProvider.getValuesCount()
        let medium = count / 2
        paymentFee = feeWaitProvider.getFee(index: medium)
    }
    
}
