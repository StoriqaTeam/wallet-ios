//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PasswordRecoveryConfirmInteractorOutput: class {
    func setFormIsValid(_ valid: Bool, passwordsEqualityMessage: String?)
    func passwordRecoverySucceed()
    func passwordRecoveryFailed(message: String)
}
