//
//  SendViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SendViewInput: class, Presentable {
    func setupInitialState(currencyImages: [UIImage], numberOfPages: Int)
    func setAmount(_ amount: String)
    func setConvertedAmount(_ amount: String)
    func setNewPage(_ index: Int)
    func setReceiverCurrencyIndex(_ index: Int)
    func setButtonEnabled(_ enabled: Bool)
}
