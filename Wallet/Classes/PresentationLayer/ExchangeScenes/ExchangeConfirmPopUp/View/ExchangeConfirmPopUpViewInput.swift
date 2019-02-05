//
//  ExchangeConfirmPopUpViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeConfirmPopUpViewInput: class, Presentable {
    func setupInitialState(fromAccount: String, toAccount: String, fromAmount: String, toAmount: String)
    func setBackgroundBlur(image: UIImage)
}
