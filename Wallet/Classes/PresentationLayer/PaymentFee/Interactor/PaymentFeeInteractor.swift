//
//  PaymentFeeInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PaymentFeeInteractor {
    weak var output: PaymentFeeInteractorOutput!
    
    private let sendProvider: SendProviderProtocol
    
    init(sendProvider: SendProviderProtocol) {
        self.sendProvider = sendProvider
    }

}


// MARK: - PaymentFeeInteractorInput

extension PaymentFeeInteractor: PaymentFeeInteractorInput {
    func setPaymentFee(index: Int) {
        sendProvider.setPaymentFee(index: index)
    }
    
    func getFeeAndWait() -> (fee: String, wait: String) {
        return sendProvider.getFeeAndWait()
    }
    
    func getSendProvider() -> SendProviderProtocol {
        return sendProvider
    }
    
    func getPaymentFeeScreenData() -> PaymentFeeScreenData {
        return sendProvider.getPaymentFeeScreenData()
    }

    func getSubtotal() -> String {
        return sendProvider.getSubtotal()
    }
    
}
