//
//  Strings+QuickLaunch.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum QuickLaunch {
        static let cancelButton = NSLocalizedString(
            "QuickLaunch.cancelButton",
            tableName: "QuickLaunch",
            value: "Do not use",
            comment: "Quick launch cancel button title")
        static let title = NSLocalizedString(
            "QuickLaunch.title",
            tableName: "QuickLaunch",
            value: "Wanna use quick launch?",
            comment: "Quick launch screen title")
        static let subtitle = NSLocalizedString(
            "QuickLaunch.subtitle",
            tableName: "QuickLaunch",
            value: "Choose the way to confirm your identity",
            comment: "Quick launch screen subtitle")
        static let setUpButton = NSLocalizedString(
            "QuickLaunch.setUpButton",
            tableName: "QuickLaunch",
            value: "Set up quick launch",
            comment: "Quick launch setup button title")
    }
}
