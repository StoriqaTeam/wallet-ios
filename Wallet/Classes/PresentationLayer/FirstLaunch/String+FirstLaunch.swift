//
//  String+FirstLaunch.swift
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
}
}
