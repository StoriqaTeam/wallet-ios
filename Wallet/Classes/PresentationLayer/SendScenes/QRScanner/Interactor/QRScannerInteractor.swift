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
    private let paymentRequestResolver: PaymentRequestResolverProtocol
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol,
         addressResolver: CryptoAddressResolverProtocol,
         paymentRequestResolver: PaymentRequestResolverProtocol) {
        
        self.sendTransactionBuilder = sendTransactionBuilder
        self.paymentRequestResolver = paymentRequestResolver
        self.addressResolver = addressResolver
        self.sendProvider = sendTransactionBuilder.build()
    }
    
}


// MARK: - QRScannerInteractorInput

extension QRScannerInteractor: QRScannerInteractorInput {
    
    func validateAddress(_ address: String) -> QRCodeAddressValidationResult {
        let selectedCurrency = sendProvider.selectedAccount.currency
        
        if let paymentRequest = paymentRequestResolver.resolve(string: address) {
            guard selectedCurrency != .btc else {
                return .wrongCurrency
            }
            return .paymentrequest(request: paymentRequest)
        }
        
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
    
    func setPaymentRequest(_ request: PaymentRequest) {
        sendTransactionBuilder.setScannedAddress(request.address)
        sendTransactionBuilder.set(cryptoAmount: request.amount)
    }
}
