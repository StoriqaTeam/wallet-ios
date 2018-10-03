//
//  SendTransactionBuilder.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 03/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SendTransactionBuilder: SendProviderBuilderProtocol {
    
    private let defaultSendTxProvider: SendTransactionProvider
    
    //FIXME: stub
    private var feeWait: [Decimal: String] = [1: "10",
                                              2: "9",
                                              3: "8",
                                              4: "7",
                                              5: "6",
                                              6: "5"]
    
    init(defaultSendTxProvider: SendTransactionProvider) {
        self.defaultSendTxProvider = defaultSendTxProvider
    }
    
    func set(account: Account) {
        defaultSendTxProvider.selectedAccount = account
    }
    
    func set(cryptoAmount: Decimal) {
        defaultSendTxProvider.amount = cryptoAmount
    }
    
    func setScannedAddress(_ address: String) {
        defaultSendTxProvider.opponentType = OpponentType.address(address: address)
        defaultSendTxProvider.scanDelegate?.didScanAddress(address)
    }
    
    func setContact(_ contact: Contact) {
        defaultSendTxProvider.opponentType = OpponentType.contact(contact: contact)
    }
    
    func setPaymentFee(index: Int) {
        let paymentFeeValues: [Decimal] = Array(feeWait.keys).sorted()
        defaultSendTxProvider.paymentFee = paymentFeeValues[index]
    }
    
    func setReceiverCurrency(_ currency: Currency) {
        defaultSendTxProvider.receiverCurrency = currency
    }
    
    func setScannedDelegate(_ delegate: QRScannerDelegate) {
        defaultSendTxProvider.scanDelegate = delegate
    }
    
    func build() -> SendTransactionProvider {
        return defaultSendTxProvider
    }
}
