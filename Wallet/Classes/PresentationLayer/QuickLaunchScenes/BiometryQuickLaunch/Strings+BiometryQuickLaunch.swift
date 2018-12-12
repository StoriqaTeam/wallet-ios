//
//  Strings+BiometryQuickLaunch.swift
//  Wallet
//
//  Created by Tata Gri on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum BiometryQuickLaunch {
        static let touchIdTitle = NSLocalizedString(
            "BiometryQuickLaunch.touchIdTitle",
            tableName: "BiometryQuickLaunch",
            value: "Set up \nfingerprint launch?",
            comment: "Biometry quick launch setup title in case of Touch ID")
        static let touchIdButton = NSLocalizedString(
            "BiometryQuickLaunch.touchIdButton",
            tableName: "BiometryQuickLaunch",
            value: "Use Touch ID",
            comment: "Biometry quick launch setup button title in case of Touch ID")
        static let faceIdTitle = NSLocalizedString(
            "BiometryQuickLaunch.faceIdTitle",
            tableName: "BiometryQuickLaunch",
            value: "Set up Face ID launch?",
            comment: "Biometry quick launch setup title in case of Face ID")
        static let faceIdButton = NSLocalizedString(
            "BiometryQuickLaunch.faceIdButton",
            tableName: "BiometryQuickLaunch",
            value: "Use Face ID",
            comment: "Biometry quick launch setup button title in case of Face ID")
    }
}
