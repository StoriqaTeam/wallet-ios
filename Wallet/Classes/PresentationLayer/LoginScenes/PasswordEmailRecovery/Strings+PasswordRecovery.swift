//
//  Strings+PasswordRecovery.swift
//  Wallet
//
//  Created by Storiqa on 13/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


import Foundation

extension Strings {
    enum PasswordRecovery {
        private static let tableName = "PasswordRecovery"
        
        static let screenTitle = NSLocalizedString(
            "PasswordRecovery.firstNamePlaceholder",
            tableName: tableName,
            value: "Password reset",
            comment: "Screen title")
        
        static let emailInputScreenSubtitle = NSLocalizedString(
            "PasswordRecovery.emailInputScreenSubtitle",
            tableName: tableName,
            value: "Enter email address to which you would like to receive the password reset link.",
            comment: "Subtitle for screen on which user enters email for password recovery")
        
        static let emailInputScreenConfirmButton = NSLocalizedString(
            "PasswordRecovery.emailInputScreenConfirmButton",
            tableName: tableName,
            value: "Reset password",
            comment: "Button title for screen on which user enters email for password reset")

        static let emailFieldPlaceholder = NSLocalizedString(
            "PasswordRecovery.emailFieldPlaceholder",
            tableName: tableName,
            value: "Your email",
            comment: "Placeholder for text field where user enters email for password reset")

        static let passwordInputScreenSubtitle = NSLocalizedString(
            "PasswordRecovery.passwordInputScreenSubtitle",
            tableName: tableName,
            value: "Create new password and confirm it.",
            comment: "Subtitle for screen on which user enters new password after password reset")

        static let passwordInputScreenConfirmButton = NSLocalizedString(
            "PasswordRecovery.passwordInputScreenConfirmButton",
            tableName: tableName,
            value: "Confirm new password",
            comment: "Button title for screen on which user enters new password after password reset")

        static let passwordFieldPlaceholder = NSLocalizedString(
            "PasswordRecovery.passwordFieldPlaceholder",
            tableName: tableName,
            value: "Password",
            comment: "Password text firld placeholder")
        
        static let passwordFieldHint = NSLocalizedString(
            "PasswordRecovery.passwordFieldHint",
            tableName: tableName,
            value: "At least: 8 characters, 1 capital, 1 digit",
            comment: "Password text firld hint. Shown below the field")

        static let repeatPasswordFieldPlaceholder = NSLocalizedString(
            "PasswordRecovery.repeatPasswordFieldPlaceholder",
            tableName: tableName,
            value: "Repeat password",
            comment: "Repeat password text firld placeholder")

    }
}
