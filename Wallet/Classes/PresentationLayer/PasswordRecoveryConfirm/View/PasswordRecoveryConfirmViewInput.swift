//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordRecoveryConfirmViewInput: class, Presentable {
    func setupInitialState()
    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?)
}
