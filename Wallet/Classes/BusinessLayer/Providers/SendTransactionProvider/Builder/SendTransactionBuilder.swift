//
//  SendTransactionBuilder.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 03/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SendTransactionBuilder: SendProviderBuilderProtocol {
    
    private lazy var defaultSendTxProvider: SendTransactionProvider = createSendTxProvider()
    
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
        defaultSendTxProvider.setPaymentFee(index: index)
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
    
    func clear() {
        defaultSendTxProvider = createSendTxProvider()
    }
}

extension SendTransactionBuilder {
    
    private func createSendTxProvider() -> SendTransactionProvider {
        let converterFactory = CurrecncyConverterFactory()
        let formatter = CurrencyFormatter()
        let accountProvider = FakeAccountProvider()
        let feeWaitProvider = FakePaymentFeeAndWaitProvider()
        
        let sendProvider = SendTransactionProvider(converterFactory: converterFactory,
                                                   currencyFormatter: formatter,
                                                   accountProvider: accountProvider,
                                                   feeWaitProvider: feeWaitProvider)
        return sendProvider
    }
    
}
