//
//  Strings+Registration.swift
//  Wallet
//
//  Created by Storiqa on 22/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

extension Strings {
    
    enum Registration {
        static let signInButtonTitle = NSLocalizedString("Registration.signInButtonTitle",
                                                         tableName: "Registration",
                                                         value: "Sign in",
                                                         comment: "Sign in button title")
        static let signUpButtonTitle = NSLocalizedString("Registration.signUpButtonTitle",
                                                         tableName: "Registration",
                                                         value: "Sign up",
                                                         comment: "Sign up button title")
        static let firstNamePlaceholder = NSLocalizedString("Registration.firstNamePlaceholder",
                                                            tableName: "Registration",
                                                            value: "First name",
                                                            comment: "First name text field placeholder")
        static let lastNamePlaceholder = NSLocalizedString("Registration.lastNamePlaceholder",
                                                            tableName: "Registration",
                                                            value: "Last name",
                                                            comment: "Last name text field placeholder")
        static let emailPlaceholder = NSLocalizedString("Registration.emailPlaceholder",
                                                        tableName: "Registration",
                                                        value: "Email",
                                                        comment: "Email placeholder")
        
        static let passwordPlaceholder = NSLocalizedString("Registration.passwordPlaceholder",
                                                           tableName: "Registration",
                                                           value: "Password",
                                                           comment: "Password placeholder")
        
        static let passwordHintTitle = NSLocalizedString("Registration.passwordHintTitle",
                                                         tableName: "Registration",
                                                         value: "At least: 8 characters, 1 capital, 1 digit",
                                                         comment: "Password hint error label title")
        
        static let repeatPasswordPlaceholder = NSLocalizedString("Registration.repeatPasswordPlaceholder",
                                                           tableName: "Registration",
                                                           value: "Repeat password",
                                                           comment: "Repeat password placeholder")
        
        static let licenseAgreementString = NSLocalizedString("Registration.licenseAgreementString",
                                                              tableName: "Registration",
                                                              value: "I accept the License Agreement",
                                                              comment: "License Agreement string")
        
        static let privacyPolicyString = NSLocalizedString("Registration.privacyPolicyString",
                                                              tableName: "Registration",
                                                              value: "I accept the Privacy Policy",
                                                              comment: "Privacy Policy string")
        
        static let passwordsNonEqualMessage = NSLocalizedString("Registration.passwordsNonEqualMessage",
                                                                tableName: "Registration",
                                                                value: "Passwords do not match",
                                                                comment: "Passwords do not match message")
        
        static let failRetrieveSocialDataMessage = NSLocalizedString("Registration.failRetrieveSocialDataMessage",
                                                                     tableName: "Registration",
                                                                     value: "We couldn’t retrieve your data from ",
                                                                     comment: "Failure message")
        
    }
}
