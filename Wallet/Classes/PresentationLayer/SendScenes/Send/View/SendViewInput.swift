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
    func updateCryptoAmountPlaceholder(_ placeholder: String)
    func setScannedAddress(_ address: String)
    func setCryptoAmount(_ amount: String)
    func setFiatAmount(_ amount: String)
    func setNewPage(_ index: Int)
    func setMedianWait(_ wait: String)
    func setPaymentFee(_ fee: String)
    func setPaymentFee(count: Int, value: Int, enabled: Bool)
    func setPaymentFeeHidden(_ hidden: Bool)
    func setFeeUpdateIndicator(hidden: Bool)
    func setAddressError(_ message: String?)
    func setButtonEnabled(_ enabled: Bool)
    func setErrorMessage(_ message: String?)
}
