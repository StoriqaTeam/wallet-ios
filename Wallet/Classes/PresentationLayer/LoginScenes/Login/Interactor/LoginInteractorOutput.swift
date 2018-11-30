//
//  LoginLoginInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol LoginInteractorOutput: class {
    func loginSucceed()
    func loginFailed(message: String)
    func formValidationFailed(email: String?, password: String?)
    func showQuickLaunch()
    func showPinQuickLaunch()
    func deviceNotRegistered()
    func deviceRegisterEmailSent()
    func failedSendDeviceRegisterEmail(message: String)
    func emailNotVerified()
    func confirmEmailSentSuccessfully(email: String)
    func confirmEmailSendingFailed(message: String)
}
