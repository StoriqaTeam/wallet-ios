//
//  PasswordEmailRecoveryPasswordEmailRecoveryViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordEmailRecoveryViewInput: class, Presentable {
    func setupInitialState()
    func setButtonEnabled(_ enabled: Bool)
    func showErrorMessage(_ message: String)
}
