//
//  RegistrationRegistrationInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

struct RegistrationData {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

class RegistrationInteractor {
    weak var output: RegistrationInteractorOutput!
    
    private var registrationData: RegistrationData?
    
    private let socialViewVM: SocialNetworkAuthViewModel
    private let formValidationProvider: RegistrationFormValidatonProviderProtocol
    
    init(socialViewVM: SocialNetworkAuthViewModel, formValidationProvider: RegistrationFormValidatonProviderProtocol) {
        self.socialViewVM = socialViewVM
        self.formValidationProvider = formValidationProvider
    }
    
}


// MARK: - RegistrationInteractorInput

extension RegistrationInteractor: RegistrationInteractorInput {
    
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
    
    func validateForm(_ form: RegistrationForm) {
        let valid = formValidationProvider.formIsValid(form)
        let passwordsEqualMessage = formValidationProvider.passwordsEqualityMessage(form)
        
        output.setFormIsValid(valid, passwordsEqualityMessage: passwordsEqualMessage)
    }
    
    func register(registrationData: RegistrationData) {
        self.registrationData = registrationData
        
        // TODO: - implement new provider
        log.warn("implement registration provider")
        
        // FIXME: - stub
        if Bool.random() {
            output.registrationSucceed(email: registrationData.email)
        } else {
            output.registrationFailed(message: Constants.Errors.userFriendly)
        }
        // ------------------------------
    }
    
    func retryRegistration() {
        guard let registrationData = registrationData else { fatalError() }
        register(registrationData: registrationData)
    }
    
}
