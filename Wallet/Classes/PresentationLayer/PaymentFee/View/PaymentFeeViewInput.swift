//
//  PaymentFeeViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PaymentFeeViewInput: class, Presentable {
    func setupInitialState(apperance: PaymentFeeScreenData)
    func setMedianWait(_ wait: String)
    func setPaymentFee(_ fee: String)
    func setSubtotal(_ subtotal: String)
}
