//
//  Strings.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import Foundation

enum Strings {
    enum Error {
        static let userFriendly = NSLocalizedString(
            "Error.userFriendly",
            tableName: "Error",
            value: "Aliens have stolen some of our servers. Chasing them, but haven’t catch them yet. Please try again or come back late",
            comment: "Is shown in case of unknown error")
        static let passwordsNonEqual = NSLocalizedString(
            "Error.passwordsNonEqual",
            tableName: "Error",
            value: "Passwords are not equeal",
            comment: "Is shown under password confirmation field when passwords do not match")
    }
    
    enum Permission {
        static let biometryAuthentication = NSLocalizedString(
            "Permission.biometryAuthentication",
            tableName: "Permission",
            value: "Authentication is needed to access your account",
            comment: "Localized reason for biometry auth")
    }
}
