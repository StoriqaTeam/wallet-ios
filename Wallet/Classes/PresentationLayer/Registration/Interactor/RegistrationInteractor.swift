//
//  RegistrationRegistrationInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class RegistrationInteractor {
    weak var output: RegistrationInteractorOutput!
    
    private let formValidationProvider: RegistrationFormValidatonProviderProtocol
    
    init(formValidationProvider: RegistrationFormValidatonProviderProtocol) {
        self.formValidationProvider = formValidationProvider
    }
    
}


// MARK: - RegistrationInteractorInput

extension RegistrationInteractor: RegistrationInteractorInput {
    
    func validateForm(_ form: RegistrationForm) {
        let valid = formValidationProvider.formIsValid(form)
        let passwordsEqualMessage = formValidationProvider.passwordsEqualityMessage(form)
        
        output.setFormIsValid(valid, passwordsEqualityMessage: passwordsEqualMessage)
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) {
        // TODO: - implement new provider
        
    }
    
}
