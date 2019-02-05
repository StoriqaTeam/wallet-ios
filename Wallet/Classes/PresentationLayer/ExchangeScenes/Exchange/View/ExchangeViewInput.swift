//
//  ExchangeViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeViewInput: class, Presentable {
    func setupInitialState()
    func setFromAmount(_ amount: String)
    func setToAmount(_ amount: String)
    func updateFromPlaceholder(_ placeholder: String)
    func updateToPlaceholder(_ placeholder: String)
    func setErrorHidden(_ hidden: Bool)
    func setButtonEnabled(_ enabled: Bool)
    func updateExpiredTimeLabel(_ time: String)
    func updateRateLabel(text: String)
    func showExchangeRateError(message: String)
}
