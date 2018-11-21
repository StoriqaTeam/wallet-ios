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
    var paymentFee: Decimal? { get }
    var receiverAddress: String { get }
    var selectedAccount: Account { get }

    func getFeeWaitCount() -> Int
    func getFeeIndex() -> Int
    func getFeeAndWait() -> (fee: Decimal?, wait: String)
    func getSubtotal() -> Decimal
    func isEnoughFunds() -> Bool
    func createTransaction() -> Transaction
}

class SendTransactionProvider: SendTransactionProviderProtocol {
    
    weak var scanDelegate: QRScannerDelegate?
    
    var selectedAccount: Account
    var amount: Decimal
    var paymentFee: Decimal?
    var receiverAddress: String
    private var feeIndex: Int?
    
    private let accountProvider: AccountsProviderProtocol
    private let feeProvider: FeeProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(accountProvider: AccountsProviderProtocol,
         feeProvider: FeeProviderProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.accountProvider = accountProvider
        self.feeProvider = feeProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        
        // default build
        self.amount = 0
        self.paymentFee = 0
        self.receiverAddress = ""
        self.selectedAccount = accountProvider.getAllAccounts().first!
    }
    
    
    // MARK: SendTransactionProviderProtocol
    
    func setPaymentFee(index: Int) {
        guard let fee = feeProvider.getFee(index: index) else {
            feeIndex = nil
            paymentFee = nil
            return
        }
        feeIndex = index
        paymentFee = fee
    }
    
    func setFees(_ fees: [EstimatedFee]?) {
        feeProvider.updateFees(fees: fees)
        
        let count = fees?.count ?? 0
        let index: Int = {
            if let feeIndex = feeIndex, count > feeIndex {
                return feeIndex
            } else {
                return count / 2
            }
        }()
        
        feeIndex = index
        paymentFee = feeProvider.getFee(index: index)
    }
    
    func getFeeIndex() -> Int {
        return feeIndex ?? 0
    }
    
    func getFeeWaitCount() -> Int {
        return feeProvider.getValuesCount()
    }
    
    func getFeeAndWait() -> (fee: Decimal?, wait: String) {
        guard let paymentFee = paymentFee else {
            return (nil, "-")
        }
        
        let currency = selectedAccount.currency
        let wait = feeProvider.getWait(fee: paymentFee)
        let fee = denominationUnitsConverter.amountToMaxUnits(paymentFee, currency: currency)
        return (fee, wait)
    }
    
    func getSubtotal() -> Decimal {
        guard !amount.isZero, let paymentFee = paymentFee else {
            return 0
        }
        
        let currency = selectedAccount.currency
        let fee = denominationUnitsConverter.amountToMaxUnits(paymentFee, currency: currency)
        let sum = amount + fee
        return sum
    }
    
    func isEnoughFunds() -> Bool {
        guard let paymentFee = paymentFee else {
            return true
        }
        
        let currency = selectedAccount.currency
        let inMinUnits = denominationUnitsConverter.amountToMinUnits(amount, currency: currency)
        let sum = inMinUnits + paymentFee
        let available = selectedAccount.balance
        return sum.isLessThanOrEqualTo(available)
    }
    
    func createTransaction() -> Transaction {
        let uuid = UUID().uuidString
        let timestamp = Date()
        let currency = selectedAccount.currency
        let fromAddress = selectedAccount.accountAddress
        let toAddress = receiverAddress
        let fee = paymentFee!
        
        let toValue = denominationUnitsConverter.amountToMinUnits(amount, currency: currency)
   
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
                                      blockchainIds: [],
                                      createdAt: timestamp,
                                      updatedAt: timestamp,
                                      status: .pending)
        return transaction
    }
    
}
