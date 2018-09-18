//
//  PasswordInputPasswordInputViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordInputViewInput: class, Presentable {
    func setupInitialState()
    func pinValidationSuccess()
    func pinValidationFail()
}
