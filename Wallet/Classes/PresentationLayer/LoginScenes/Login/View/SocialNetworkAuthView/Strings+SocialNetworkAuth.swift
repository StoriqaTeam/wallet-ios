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
        
        static let orLabel = NSLocalizedString(
            "SocialNetworkAuth.orLabel",
            tableName: tableName,
            value: "or",
            comment: "")
        static let signInTitle = NSLocalizedString(
            "SocialNetworkAuth.signInTitle",
            tableName: tableName,
            value: "Sign in via ",
            comment: "")
        static let signUpTitle = NSLocalizedString(
            "SocialNetworkAuth.signUpTitle",
            tableName: tableName,
            value: "Sign up via ",
            comment: "")
    }
    
}
