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
        static let repeatPasswordPlaceholder = NSLocalizedString("Registration.repeatPasswordPlaceholder",
                                                           tableName: "Registration",
                                                           value: "Repeat password",
                                                           comment: "Repeat password placeholder")
        static let acceptAgreementLabel = NSLocalizedString("Registration.acceptAgreementLabel",
                                                            tableName: "Registration",
                                                            value: "I accept the terms of the license agreement and privacy policy",
                                                            comment: "Accept agreement label title")
        
        static let signUpButtonTitle = NSLocalizedString("Registration.signUpButtonTitle",
                                                         tableName: "Registration",
                                                         value: "Sign up",
                                                         comment: "Sign up button title")
        
    }
}
