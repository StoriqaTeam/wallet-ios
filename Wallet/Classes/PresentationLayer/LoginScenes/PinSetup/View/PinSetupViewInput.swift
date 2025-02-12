//
//  PinSetupViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PinSetupViewInput: class, Presentable {
    func setupInitialState()
    func setTitle(title: String, subtitle: String)
}
