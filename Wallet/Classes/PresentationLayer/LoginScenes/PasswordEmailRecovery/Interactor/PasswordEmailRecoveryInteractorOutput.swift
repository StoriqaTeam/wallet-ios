//
//  PasswordEmailRecoveryPasswordEmailRecoveryInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PasswordEmailRecoveryInteractorOutput: class {
    func setFormIsValid(_ valid: Bool)
    func emailSentSuccessfully()
    func emailSendingFailed(message: String)
    func emailNotVerified()
    func confirmEmailSentSuccessfully(email: String)
    func confirmEmailSendingFailed(message: String)
    func formValidationFailed(_ message: String)
}
