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
    
    func setRecepientAccount(_ recepient: String)
    func setAmount(_ amount: String)
    func setConvertedAmount(_ amount: String)
    func setNewPage(_ index: Int)
    func setMedianWait(_ wait: String)
    func setPaymentFee(_ fee: String)
    func setPaymentFee(count: Int, value: Int)
    func setSubtotal(_ subtotal: String)
    func setErrorHidden(_ hidden: Bool)
    func setButtonEnabled(_ enabled: Bool)
    func showAccountsActionSheet(height: CGFloat)
    func hideAccountsActionSheet()
}
