//
//  SendTransactionBuilder.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 03/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SendTransactionBuilder: SendProviderBuilderProtocol {
    
    private var defaultSendTxProvider: SendTransactionProvider
    
    private let currencyConverterFactory: CurrencyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let accountsProvider: AccountsProviderProtocol
    private let feeWaitProvider: PaymentFeeAndWaitProviderProtocol
    
    init(currencyConverterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountsProvider: AccountsProviderProtocol,
         feeWaitProvider: PaymentFeeAndWaitProviderProtocol) {
        
        
        self.currencyConverterFactory = currencyConverterFactory
        self.currencyFormatter = currencyFormatter
        self.accountsProvider = accountsProvider
        self.feeWaitProvider = feeWaitProvider
        
        defaultSendTxProvider = SendTransactionProvider(converterFactory: self.currencyConverterFactory,
                                                        currencyFormatter: self.currencyFormatter,
                                                        accountProvider: self.accountsProvider,
                                                        feeWaitProvider: self.feeWaitProvider)
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
    
    func setContact(_ contact: ContactDisplayable) {
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
        defaultSendTxProvider = SendTransactionProvider(converterFactory: self.currencyConverterFactory,
                                                        currencyFormatter: self.currencyFormatter,
                                                        accountProvider: self.accountsProvider,
                                                        feeWaitProvider: self.feeWaitProvider)
    }
}
