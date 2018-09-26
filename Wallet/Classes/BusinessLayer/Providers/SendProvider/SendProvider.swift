//
//  SendProvider.swift
//  Wallet
//
//  Created by Storiqa on 25.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol QRScannerDelegate: class {
    func didScanAddress(_ address: String)
}

protocol SendProviderProtocol: class {
    var scanDelegate: QRScannerDelegate? { set get }
    
    var selectedAccount: Account? { set get }
    var receiverCurrency: Currency? { set get }
    var amount: String? { set get }
    var amountInSelfAccCurrency: String? { set get }
    var paymentFee: String? { set get }
    var opponentType: OpponentType? { set get }
    
    func setScannedAddress(_ address: String)
}

class SendProvider: SendProviderProtocol {
    weak var scanDelegate: QRScannerDelegate?
    
    var selectedAccount: Account?
    var receiverCurrency: Currency?
    var amount: String?
    var amountInSelfAccCurrency: String?
    var paymentFee: String?
    var opponentType: OpponentType?
    
    func setScannedAddress(_ address: String) {
        opponentType = OpponentType.address(address: address)
        scanDelegate?.didScanAddress(address)
    }
    
}
