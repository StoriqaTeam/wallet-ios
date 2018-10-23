//
//  Strings+Login.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum SocialNetworkAuth {
        static let sighInTitle = NSLocalizedString("SocialNetworkAuth.signInTitle",
                                                   tableName: "SocialNetworkAuth",
                                                   value: "Sign in via social account",
                                                   comment: "Sign in label title")
        
        static let noAccountsTitle = NSLocalizedString("SocialNetworkAuth.noAccountsTitle",
                                                       tableName: "SocialNetworkAuth",
                                                       value: "Haven’t got account?",
                                                       comment: "No account footer title label")
        
        static let registerButtonTitle = NSLocalizedString("SocialNetworkAuth.registerButtonTitle",
                                                           tableName: "SocialNetworkAuth",
                                                           value: "Register",
                                                           comment: "Register footer button title")
        
        static let sighUpTitle = NSLocalizedString("SocialNetworkAuth.signUpTitle",
                                                   tableName: "SocialNetworkAuth",
                                                   value: "Sign up via social account",
                                                   comment: "Sign up label title")
        
        static let haveAccountTitle = NSLocalizedString("SocialNetworkAuth.haveAccountTitle",
                                                        tableName: "SocialNetworkAuth",
                                                        value: "Have an account?",
                                                        comment: "Have account footer title label")
        
        static let signInButton = NSLocalizedString("SocialNetworkAuth.signInButton",
                                                    tableName: "SocialNetworkAuth",
                                                    value: "Sign in",
                                                    comment: "Sign in button label")
        
        
    }
}
