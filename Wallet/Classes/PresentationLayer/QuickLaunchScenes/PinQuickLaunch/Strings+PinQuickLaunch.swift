//
//  Strings+PinQuickLaunch.swift
//  Wallet
//
//  Created by Tata Gri on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum PinQuickLaunch {
        static let title = NSLocalizedString(
            "PinQuickLaunch.title",
            tableName: "PinQuickLaunch",
            value: "Set up PIN code?",
            comment: "Pin launch screen title")
        static let button = NSLocalizedString(
            "PinQuickLaunch.button",
            tableName: "PinQuickLaunch",
            value: "Set up PIN code",
            comment: "Pin launch screen button title")
    }
}
