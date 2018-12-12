//
//  Strings+Login.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    enum Login {
        static let emailPlaceholder = NSLocalizedString("Login.emailPlaceholder",
                                                        tableName: "Login",
                                                        value: "Email",
                                                        comment: "Email placeholder")
        static let passwordPlaceholder = NSLocalizedString("Login.passwordPlaceholder",
                                                           tableName: "Login",
                                                           value: "Password",
                                                           comment: "Password placeholder")
        static let signInButtonTitle = NSLocalizedString("Login.signInButtonTitle",
                                                         tableName: "Login",
                                                         value: "Sign in",
                                                         comment: "Sign in button Title")
        static let forgotButtonTitle = NSLocalizedString("Login.forgotButtonTitle",
                                                         tableName: "Login",
                                                         value: "I forgot password",
                                                         comment: "Forgot password  button title")
        
    }
}
