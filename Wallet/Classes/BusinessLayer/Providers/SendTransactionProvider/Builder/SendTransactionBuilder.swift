//
//  SendTransactionBuilder.swift
//  Wallet
//
//  Created by Storiqa on 03/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SendTransactionBuilder: SendProviderBuilderProtocol {
    
    private var defaultSendTxProvider: SendTransactionProvider
    
    private let accountsProvider: AccountsProviderProtocol
    private let feeProvider: FeeProviderProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(currencyConverterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountsProvider: AccountsProviderProtocol,
         feeProvider: FeeProviderProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.accountsProvider = accountsProvider
        self.feeProvider = feeProvider
        self.denominationUnitsConverter = denominationUnitsConverter
        
        defaultSendTxProvider = SendTransactionProvider(accountProvider: self.accountsProvider,
                                                        feeProvider: self.feeProvider,
                                                        denominationUnitsConverter: self.denominationUnitsConverter)
    }
    
    func set(account: Account) {
        defaultSendTxProvider.selectedAccount = account
    }
    
    func set(cryptoAmount: Decimal) {
        defaultSendTxProvider.amount = cryptoAmount
    }
    
    func setAddress(_ address: String) {
        defaultSendTxProvider.receiverAddress = address
    }
    
    func setScannedAddress(_ address: String) {
        defaultSendTxProvider.scanDelegate?.didScanAddress(address)
    }
    
    func setPaymentFee(index: Int) {
        defaultSendTxProvider.setPaymentFee(index: index)
    }
    
    func setScannedDelegate(_ delegate: QRScannerDelegate) {
        defaultSendTxProvider.scanDelegate = delegate
    }
    
    func setFees(_ fees: [EstimatedFee]?) {
        defaultSendTxProvider.setFees(fees)
    }
    
    func build() -> SendTransactionProvider {
        return defaultSendTxProvider
    }
    
    func clear() {
        defaultSendTxProvider = SendTransactionProvider(accountProvider: self.accountsProvider,
                                                        feeProvider: self.feeProvider,
                                                        denominationUnitsConverter: self.denominationUnitsConverter)
    }
}
