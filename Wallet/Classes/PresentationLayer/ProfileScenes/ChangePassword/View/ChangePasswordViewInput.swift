//
//  ChangePasswordViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ChangePasswordViewInput: class, Presentable {
    func setupInitialState()
    func setPasswordsEqual(_ equal: Bool, message: String?)
    func setButtonEnabled(_ enabled: Bool)
    func showErrorMessage(oldPassword: String?, newPassword: String?)
}
