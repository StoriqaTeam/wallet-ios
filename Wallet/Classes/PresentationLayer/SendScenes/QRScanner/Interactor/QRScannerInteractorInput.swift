//
//  QRScannerInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import AVFoundation


enum QRCodeAddressValidationResult {
    case succeed
    case wrongCurrency
    case failed
    case paymentrequest(request: PaymentRequest)
}

protocol QRScannerInteractorInput: class {
    func setScannedAddress(_ address: String)
    func validateAddress(_ address: String) -> QRCodeAddressValidationResult
    func setPaymentRequest(_ request: PaymentRequest)
}
