//
//  ExchangeViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeViewInput: class, Presentable {
    func setupInitialState(numberOfPages: Int)
    func updatePagesCount(_ count: Int)
    func setRecepientAccount(_ recepient: String)
    func setRecepientBalance(_ balance: String)
    func setAmount(_ amount: String)
    func setNewPage(_ index: Int)
    func setGive(_ amount: String)
    func setGet(_ amount: String)
    func setErrorHidden(_ hidden: Bool)
    func setButtonEnabled(_ enabled: Bool)
    func updateExpiredTimeLabel(_ time: String)
    func updateRateLabel(text: String)
    func showExchangeRateError(message: String)
}
