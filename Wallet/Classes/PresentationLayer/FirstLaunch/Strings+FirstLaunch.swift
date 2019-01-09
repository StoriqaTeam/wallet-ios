//
//  Strings+FirstLaunch.swift
//  Wallet
//
//  Created by Storiqa on 14/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


extension Strings {
    enum FirstLaunch {
        static let getStartedButton = NSLocalizedString(
            "FirstLaunch.getStartedButton",
            tableName: "FirstLaunch",
            value: "Get started",
            comment: "Get started button. Routes to register screen")
        
        static let signInButton = NSLocalizedString(
            "FirstLaunch.signInButton",
            tableName: "FirstLaunch",
            value: "Sign in",
            comment: "Sign in button. Routes to login screen")
        
        static let subtitle = NSLocalizedString(
            "FirstLaunch.subtitle",
            tableName: "FirstLaunch",
            value: "Multicurrency wallet for easy operations with your fiat & crypto funds",
            comment: "First launch screen subtitle")
    }
}
