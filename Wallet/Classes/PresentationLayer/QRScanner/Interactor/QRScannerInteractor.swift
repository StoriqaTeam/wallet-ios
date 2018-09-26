//
//  QRScannerInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import AVFoundation


class QRScannerInteractor {
    weak var output: QRScannerInteractorOutput!
    
    private let sendProvider: SendTransactionBuilderProtocol
    private let qrCodeValidator: QRCodeValidatorProtocol
    
    init(sendProvider: SendTransactionBuilderProtocol, qrCodeValidator: QRCodeValidatorProtocol) {
        self.sendProvider = sendProvider
        self.qrCodeValidator = qrCodeValidator
    }
    
}


// MARK: - QRScannerInteractorInput

extension QRScannerInteractor: QRScannerInteractorInput {
    
    func isValidAddress(_ address: String) -> Bool {
        return qrCodeValidator.isBTCWalletAddress(address) || qrCodeValidator.isETHWalletAddress(address)
    }
    
    func setScannedAddress(_ address: String) {
        sendProvider.setScannedAddress(address)
    }
    
}
