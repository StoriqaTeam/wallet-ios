//
//  Strings+SocialNetworkAuth.swift
//  Wallet
//
//  Created by Storiqa on 13/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    
    enum SocialNetworkAuth {
        private static let tableName = "SocialNetworkAuth"
        
        static let signInTitle = NSLocalizedString(
            "SocialNetworkAuth.signInTitle",
            tableName: tableName,
            value: "Sign in via social account",
            comment: "")
        static let signInFooter = NSLocalizedString(
            "SocialNetworkAuth.signInFooter",
            tableName: tableName,
            value: "Haven’t got account?",
            comment: "")
        static let registerButton = NSLocalizedString(
            "SocialNetworkAuth.registerButton",
            tableName: tableName,
            value: "Register",
            comment: "")
        static let signUpTitle = NSLocalizedString(
            "SocialNetworkAuth.signUpTitle",
            tableName: tableName,
            value: "Sign up via social account",
            comment: "")
        static let signUpFooter = NSLocalizedString(
            "SocialNetworkAuth.signUpFooter",
            tableName: tableName,
            value: "Have an account?",
            comment: "")
        static let signInButton = NSLocalizedString(
            "SocialNetworkAuth.signInButton",
            tableName: tableName,
            value: "Sign in",
            comment: "")
    }
    
}
