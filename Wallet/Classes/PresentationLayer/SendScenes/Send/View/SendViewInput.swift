//
//  SendViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SendViewInput: class, Presentable {
    func setupInitialState(numberOfPages: Int)
    func updatePagesCount(_ count: Int)
    func setScannedAddress(_ address: String)
    func setAmount(_ amount: String)
    func setNewPage(_ index: Int)
    func setMedianWait(_ wait: String)
    func setPaymentFee(_ fee: String)
    func setPaymentFee(count: Int, value: Int, enabled: Bool)
    func setFeeUpdateIndicator(hidden: Bool)
    func setSubtotal(_ subtotal: String)
    func setAddressError(_ message: String?)
    func setButtonEnabled(_ enabled: Bool)
    func setEnoughFundsErrorHidden(_ errorHidden: Bool)
}
