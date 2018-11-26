//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PasswordRecoveryConfirmInteractorInput: class {
    func confirmReset(newPassword: String)
    func validateForm(withMessage: Bool, newPassword: String?, passwordConfirm: String?)
    func retry()
}
