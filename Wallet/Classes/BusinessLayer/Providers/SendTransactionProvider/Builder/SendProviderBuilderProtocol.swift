//
//  Builder.swift
//  Wallet
//
//  Created by Storiqa on 02/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SendProviderBuilderProtocol: class {
    func set(account: Account)
    func set(cryptoAmount: Decimal)
    func set(fiatAmount: Decimal)
    func setAddress(_ address: String)
    func setScannedAddress(_ address: String)
    func setPaymentFee(index: Int)
    func setScannedDelegate(_ delegate: QRScannerDelegate)
    func setFees(_ fees: [EstimatedFee]?)
    func build() -> SendTransactionProvider
    func clear()
}
