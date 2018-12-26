//
//  Strings+Settings.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    enum Settings {
        static let navigationBarTitle = NSLocalizedString(
            "Settings.navigationBarTitle",
            tableName: "Settings",
            value: "Menu",
            comment: "Screen title")

        static let editProfile = NSLocalizedString(
            "Settings.editProfile",
            tableName: "Settings",
            value: "Edit profile",
            comment: "Edit profile menu line")

        static let changePassword = NSLocalizedString(
            "Settings.changePassword",
            tableName: "Settings",
            value: "Change password",
            comment: "Change password menu line")

        static let appInfo = NSLocalizedString(
            "Settings.appInfo",
            tableName: "Settings",
            value: "App info",
            comment: "App info menu line")

        static let changePhone = NSLocalizedString(
            "Settings.changePhone",
            tableName: "Settings",
            value: "Change phone number",
            comment: "Change phone number menu line")

        static let connectPhone = NSLocalizedString(
            "Settings.connectPhone",
            tableName: "Settings",
            value: "Connect phone number",
            comment: "Connect phone number menu line")
    }
}
