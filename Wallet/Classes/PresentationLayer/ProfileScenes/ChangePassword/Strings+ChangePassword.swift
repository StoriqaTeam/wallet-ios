//
//  Strings+ChangePassword.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    enum ChangePassword {
        static let screenTitle = NSLocalizedString(
            "ChangePassword.screenTitle",
            tableName: "ChangePassword",
            value: "Change password",
            comment: "Screen title")
        
        static let currentPasswordPlaceholder = NSLocalizedString(
            "ChangePassword.currentPasswordPlaceholder",
            tableName: "ChangePassword",
            value: "Current password",
            comment: "Current password input placeholder")

        static let newPasswordPlaceholder = NSLocalizedString(
            "ChangePassword.newPasswordPlaceholder",
            tableName: "ChangePassword",
            value: "New password",
            comment: "New password input placeholder")

        static let repeatPasswordPlaceholder = NSLocalizedString(
            "ChangePassword.repeatPasswordPlaceholder",
            tableName: "ChangePassword",
            value: "Repeat password",
            comment: "Repeat password input placeholder")

        static let changePasswordButton = NSLocalizedString(
            "ChangePassword.changePasswordButton",
            tableName: "ChangePassword",
            value: "Change password",
            comment: "Change password button")
        
        static let newPasswordHint = NSLocalizedString(
            "ChangePassword.newPasswordHint",
            tableName: "ChangePassword",
            value: "At least: 8 characters, 1 capital, 1 digit",
            comment: "New password input hint. Shown below text field")
        
        static let passwordsNotMatchMessage = NSLocalizedString(
            "ChangePassword.passwordsNotMatchMessage",
            tableName: "ChangePassword",
            value: "Passwords do not match",
            comment: "Shown when new password and it's confirmation do not match")
    }
}
