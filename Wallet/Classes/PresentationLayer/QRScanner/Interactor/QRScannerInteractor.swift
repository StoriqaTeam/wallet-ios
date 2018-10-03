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
    
    private let sendTransactionBuilder: SendProviderBuilderProtocol
    private let addressResolver: CryptoAddressResolverProtocol

    
    init(sendTransactionBuilder: SendProviderBuilderProtocol, addressResolver: CryptoAddressResolverProtocol) {
        self.sendTransactionBuilder = sendTransactionBuilder
        self.addressResolver = addressResolver
    }
    
}


// MARK: - QRScannerInteractorInput

extension QRScannerInteractor: QRScannerInteractorInput {
    
    func isValidAddress(_ address: String) -> Bool {
        return addressResolver.resove(address: address) != nil 
    }
    
    func setScannedAddress(_ address: String) {
        sendTransactionBuilder.setScannedAddress(address)
    }
    
}
