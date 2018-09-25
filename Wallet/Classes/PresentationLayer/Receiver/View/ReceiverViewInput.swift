//
//  ReceiverViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ReceiverViewInput: class, Presentable {
    func setupInitialState(amount: String, convertedAmount: String)
    func setInput(_ input: String)
}
