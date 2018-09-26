//
//  SendProvider.swift
//  Wallet
//
//  Created by Storiqa on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct SendingHeaderData {
    let amount: String
    let amountInTransactionCurrency: String
    let currencyImage: UIImage
}

struct PaymentFeeScreenData {
    let header: SendingHeaderData
    let address: String
    let receiverName: String
    let paymentFeeValuesCount: Int
}

protocol QRScannerDelegate: class {
    func didScanAddress(_ address: String)
}

protocol SendProviderProtocol: class {
    var scanDelegate: QRScannerDelegate? { set get }
    
    func getSendingHeaderData() -> SendingHeaderData
    func getPaymentFeeScreenData() -> PaymentFeeScreenData
    func getAmountInTransactionCurrency(amount: String, in currency: Currency, from account: Account) -> String
    func getFeeAndWait() -> (fee: String, wait: String)
    func getSubtotal() -> String
    
    func set(selectedAccount: Account, receiverCurrency: Currency, amount: String)
    func setScannedAddress(_ address: String)
    func setContact(_ contact: Contact)
    func setPaymentFee(index: Int)
}

class SendProvider: SendProviderProtocol {
    
    weak var scanDelegate: QRScannerDelegate?
    
    private var selectedAccount: Account!
    private var receiverCurrency: Currency!
    private var amount: String!
    private var amountInTransactionCurrency: String!
    private var paymentFee: Decimal!
    private var opponentType: OpponentType!
    
    //TODO: stub
    private var feeWait: [Decimal: String] = [1: "10",
                                              2: "9",
                                              3: "8",
                                              4: "7",
                                              5: "6",
                                              6: "5"]
    
    func getAmountInTransactionCurrency(amount: String, in currency: Currency, from account: Account) -> String {
        //TODO: converter
        return "000000.00" + " " + account.currency.ISO
    }
    
    func set(selectedAccount: Account, receiverCurrency: Currency, amount: String) {
        self.selectedAccount = selectedAccount
        self.amount = amount
        self.receiverCurrency = receiverCurrency
        self.amountInTransactionCurrency = getAmountInTransactionCurrency(amount: amount, in: receiverCurrency, from: selectedAccount)
    }
    
    func setScannedAddress(_ address: String) {
        opponentType = OpponentType.address(address: address)
        scanDelegate?.didScanAddress(address)
    }
    
    func setContact(_ contact: Contact) {
        opponentType = OpponentType.contact(contact: contact)
    }
    
    func getSendingHeaderData() -> SendingHeaderData {
        let amount = self.amount + " " + receiverCurrency.ISO
        let amountInTransactionCurrency = "=" + self.amountInTransactionCurrency
        let image = receiverCurrency.image
        
        return SendingHeaderData(amount: amount,
                                   amountInTransactionCurrency: amountInTransactionCurrency,
                                   currencyImage: image)
    }
    
    func getPaymentFeeScreenData() -> PaymentFeeScreenData {
        let address: String
        
        switch opponentType! {
        case .contact:
            //TODO: будем получать?
            address = "test address"
        case .address(let addr):
            address = addr
        }
        
        //TODO: stub
        let receiverName = "Receiver Name"
        
        return PaymentFeeScreenData(header: getSendingHeaderData(),
                                    address: address,
                                    receiverName: receiverName,
                                    paymentFeeValuesCount: feeWait.count)
        
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
        //TODO: считать сумму
        return "000000.000 " + selectedAccount.currency.ISO
    }
    
}
