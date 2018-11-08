//
//  RegistrationRegistrationInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RegistrationInteractorOutput: class {
    func registrationSucceed(email: String)
    func registrationFailed(message: String)
    func formValidationFailed(email: String?, password: String?)
    func setFormIsValid(_ valid: Bool)
    func showQuickLaunch()
    func showPinQuickLaunch()
    func socialAuthFailed(message: String)
}
