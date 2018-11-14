//
//  SendConfirmPopUpViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 14/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SendConfirmPopUpViewInput: class, Presentable {
    func setupInitialState(address: String, amount: String, fee: String)
}
