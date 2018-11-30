//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol PasswordRecoveryConfirmViewOutput: class {
    func viewIsReady()
    func validateForm(withMessage: Bool, newPassword: String?, passwordConfirm: String?)
    func confirmReset(newPassword: String)
}
