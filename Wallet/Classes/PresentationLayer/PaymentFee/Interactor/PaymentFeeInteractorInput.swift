//
//  PaymentFeeInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PaymentFeeInteractorInput: class {
    func getPaymentFeeScreenData() -> PaymentFeeScreenData
    func getSendTransactionBuilder() -> SendTransactionBuilderProtocol
    func setPaymentFee(index: Int)
    func getFeeAndWait() -> (fee: String, wait: String)
    func getSubtotal() -> String
}
