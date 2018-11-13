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
    private var sendProvider: SendTransactionProviderProtocol!
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol, addressResolver: CryptoAddressResolverProtocol) {
        self.sendTransactionBuilder = sendTransactionBuilder
        self.addressResolver = addressResolver
        self.sendProvider = sendTransactionBuilder.build()
    }
    
}


// MARK: - QRScannerInteractorInput

extension QRScannerInteractor: QRScannerInteractorInput {
    
    func validateAddress(_ address: String) -> QRCodeAddressValidationResult {
        let selectedCurrency = sendProvider.selectedAccount.currency
        
        guard let scannedCurrency = addressResolver.resove(address: address) else {
            return .failed
        }
        
        switch scannedCurrency {
        case .btc where selectedCurrency == .btc,
             .eth where selectedCurrency == .eth || selectedCurrency == .stq:
            return .succeed
        default:
            return .wrongCurrency
        }
    
    }
    
    func setScannedAddress(_ address: String) {
        sendTransactionBuilder.setScannedAddress(address)
    }
    
}
