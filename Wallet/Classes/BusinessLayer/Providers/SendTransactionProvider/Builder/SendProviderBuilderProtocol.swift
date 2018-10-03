//
//  Builder.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 02/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SendProviderBuilderProtocol: class {
    func set(account: Account)
    func set(cryptoAmount: Decimal)
    func setScannedAddress(_ address: String)
    func setContact(_ contact: Contact)
    func setPaymentFee(index: Int)
    func setReceiverCurrency(_ currency: Currency)
    func setScannedDelegate(_ delegate: QRScannerDelegate)
    func build() -> SendTransactionProvider
}