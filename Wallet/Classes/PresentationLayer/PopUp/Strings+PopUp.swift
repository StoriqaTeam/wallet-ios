//
//  Strings+PopUp.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum PopUp {
        private static let tableName = "PopUp"
        
        static let deviceRegisterTitle = NSLocalizedString(
            "PopUp.deviceRegisterTitle",
            tableName: tableName,
            value: "Your device is not registered yet",
            comment: "Shown when user tries to sing in on not registered device.")
        
        static let deviceRegisterMessage = NSLocalizedString(
            "PopUp.deviceRegisterMessage",
            tableName: tableName,
            value: "Do you want to allow your account to be accessible from this device?",
            comment: "Shown when user tries to sing in on not registered device.")
        
        static let okButton = NSLocalizedString(
            "PopUp.okButton",
            tableName: tableName,
            value: "OK",
            comment: "Just ok button")
        
        static let emailSentTitle = NSLocalizedString(
            "PopUp.emailSentTitle",
            tableName: tableName,
            value: "Email sent successfully",
            comment: "Text is shown when email is sent. Shown on user registration, device registration, password recovery")
        
        static let registerDeviceEmailMessage = NSLocalizedString(
            "PopUp.registerEmailMessage",
            tableName: tableName,
            value: "Check your mailbox and follow the link to register your device",
            comment: "Text shown when email is send on device registration")
        
        static let failureTitle = NSLocalizedString(
            "PopUp.failureTitle",
            tableName: tableName,
            value: "Oops! Something went wrong.",
            comment: "General error title")
        
        static let tryAgainButton = NSLocalizedString(
            "PopUp.tryAgainButton",
            tableName: tableName,
            value: "Try again",
            comment: "Try again button")
        
        static let resendConfirmEmailTitle = NSLocalizedString(
            "PopUp.resendConfirmEmailTitle",
            tableName: tableName,
            value: "Your email is not verified",
            comment: "Title. Shown when user tries to confirm registration with expired link from letter.")
        
        static let resendConfirmEmailMessage = NSLocalizedString(
            "PopUp.resendConfirmEmailMessage",
            tableName: tableName,
            value: "The link we’ve sent you has expired. Tap ‘Resend’ to get a new link to verify your account.",
            comment: "Message. Shown when user tries to confirm registration with expired link from letter.")
        
        static let resendButton = NSLocalizedString(
            "PopUp.resendButton",
            tableName: tableName,
            value: "Resend",
            comment: "Resend button")
        
        static let registrationMessage = NSLocalizedString(
            "PopUp.registrationMessage",
            tableName: tableName,
            value: "Check your mailbox! We've sent you an email address confirmation link to ",
            comment: "Text shown when email is send on user registration")
        
        static let passwordEmailRecoveryMessage = NSLocalizedString(
            "PopUp.passwordEmailRecoveryMessage",
            tableName: tableName,
            value: "Check your mailbox and follow the link to reset your password",
            comment: "Text shown when email is send on password reset")
        
        static let passwordRecoveryConfirmTitle = NSLocalizedString(
            "PopUp.passwordRecoveryConfirmTitle",
            tableName: tableName,
            value: "Password reset complete",
            comment: "Shown when password was successfully reset")

        static let passwordRecoveryConfirmMessage = NSLocalizedString(
            "PopUp.passwordRecoveryConfirmMessage",
            tableName: tableName,
            value: "You have successfully set up new password.",
            comment: "Shown when password was successfully reset")
        
        static let signInButton = NSLocalizedString(
            "PopUp.signInButton",
            tableName: tableName,
            value: "Sign in",
            comment: "Sign in button")

        static let emailConfirmTitle = NSLocalizedString(
            "PopUp.emailConfirmTitle",
            tableName: tableName,
            value: "Email was successfully confirmed",
            comment: "SHown when registration was completed with successfull email comfirmation")

        static let deviceRegisterSuccessTitle = NSLocalizedString(
            "PopUp.deviceRegisterSuccessTitle",
            tableName: tableName,
            value: "Device was successfully registered",
            comment: "Shown when device was successfully registered to user account")

        static let sendTransactionTitle = NSLocalizedString(
            "PopUp.sendTransactionTitle",
            tableName: tableName,
            value: "Transaction sent successfully",
            comment: "Shown when transaction was successfully sent")

        static let changePasswordTitle = NSLocalizedString(
            "PopUp.changePasswordTitle",
            tableName: tableName,
            value: "Password was changed successfully",
            comment: "Shown when password was successfully changed")

        static let signOutTitle = NSLocalizedString(
            "PopUp.signOutTitle",
            tableName: tableName,
            value: "Would like to sign out?",
            comment: "Title. Shown to confirm that user wants to sign out")

        static let signOutMessage = NSLocalizedString(
            "PopUp.signOutMessage",
            tableName: tableName,
            value: "After signing out you won’t be able to receive notifications from TURE.",
            comment: "Message. Shown to confirm that user wants to sign out")

        static let signOutButton = NSLocalizedString(
            "PopUp.signOutButton",
            tableName: tableName,
            value: "Yes, sign out",
            comment: "Button to confirm sign out")
        
        static let noButton = NSLocalizedString(
            "PopUp.noButton",
            tableName: tableName,
            value: "No",
            comment: "Button to cancel sign out")
        
        static let yesButton = NSLocalizedString(
            "PopUp.yesButton",
            tableName: tableName,
            value: "Yes",
            comment: "Yes button")

        static let cancelButton = NSLocalizedString(
            "PopUp.cancelButton",
            tableName: tableName,
            value: "Cancel",
            comment: "Cancel button")
    }
}
