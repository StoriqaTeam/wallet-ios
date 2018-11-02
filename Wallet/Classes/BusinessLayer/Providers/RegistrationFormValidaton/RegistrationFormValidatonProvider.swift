//
//  RegistrationFormValidatonProvider.swift
//  Wallet
//
//  Created by Storiqa on 18.09.2018.
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
            email.isValidEmail() &&
            !password.isEmpty &&
            !repeatPassword.isEmpty &&
            form.agreement &&
            password == repeatPassword
        
        return formIsValid
    }
    
}
