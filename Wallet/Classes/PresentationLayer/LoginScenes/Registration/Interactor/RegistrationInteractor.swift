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
    private let registrationNetworkProvider: RegistrationNetworkProviderProtocol
    
    init(socialViewVM: SocialNetworkAuthViewModel,
         formValidationProvider: RegistrationFormValidatonProviderProtocol,
         registrationNetworkProvider: RegistrationNetworkProviderProtocol) {
        self.socialViewVM = socialViewVM
        self.formValidationProvider = formValidationProvider
        self.registrationNetworkProvider = registrationNetworkProvider
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
    
    func register(with registrationData: RegistrationData) {
        self.registrationData = registrationData
        
        // TODO: - implement new provider
        log.warn("implement registration provider")
        
        registrationNetworkProvider.register(
            email: registrationData.email,
            password: registrationData.password,
            firstName: registrationData.firstName,
            lastName: registrationData.lastName,
            queue: .main) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success:
                    strongSelf.output.registrationSucceed(email: registrationData.email)
                case .failure(let error):
                    strongSelf.output.registrationFailed(message: error.localizedDescription)
                }
        }
    }
    
    func retryRegistration() {
        guard let registrationData = registrationData else {
            fatalError("trying to retry registration without registrationData")
        }
        register(with: registrationData)
    }
}
