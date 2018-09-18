//
//  RegistrationFormValidatonProvider.swift
//  Wallet
//
//  Created by user on 18.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct RegistrationForm {
    let firstName: String?
    let lastName: String?
    let email: String?
    let password: String?
    let repeatPassword: String?
    let agreement: Bool
}

protocol RegistrationFormValidatonProviderProtocol {
    func formIsValid(_ form: RegistrationForm) -> Bool
    func passwordsEqualityMessage(_ form: RegistrationForm) -> String?
}

class RegistrationFormValidatonProvider: RegistrationFormValidatonProviderProtocol {
    
    func formIsValid(_ form: RegistrationForm) -> Bool {
        guard let firstName = form.firstName,
            let lastName = form.lastName,
            let email = form.email,
            let password = form.password,
            let repeatPassword = form.repeatPassword
            else {
                return false
        }
        
        let formIsValid =
            !firstName.isEmpty &&
            !lastName.isEmpty &&
            Validations.isValidEmail(email) &&
            !password.isEmpty &&
            !repeatPassword.isEmpty &&
            form.agreement &&
            password == repeatPassword
        
        return formIsValid
    }
    
    func passwordsEqualityMessage(_ form: RegistrationForm) -> String? {
        guard let password = form.password, !password.isEmpty,
            let repeatPassword = form.repeatPassword, !repeatPassword.isEmpty else {
            return nil
        }
        
        return password != repeatPassword ? "passwords_nonequeal".localized() : nil
    }
    
}
