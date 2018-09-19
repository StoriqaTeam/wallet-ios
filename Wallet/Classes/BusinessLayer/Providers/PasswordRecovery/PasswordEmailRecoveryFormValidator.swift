//
//  PasswordEmailRecoveryFormValidator.swift
//  Wallet
//
//  Created by Storiqa on 19.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PasswordEmailRecoveryFormValidatorProtocol {
    func emailIsValid(_ email: String) -> Bool
}

class PasswordEmailRecoveryFormValidator: PasswordEmailRecoveryFormValidatorProtocol {
    
    func emailIsValid(_ email: String) -> Bool {
        return Validations.isValidEmail(email)
    }
    
}
