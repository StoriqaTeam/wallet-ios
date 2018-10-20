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
    private let reginstrationNetworkProvider: RegistrationNetworkProviderProtocol
    private let userDataStore: UserDataStoreServiceProtocol
    
    init(socialViewVM: SocialNetworkAuthViewModel,
         formValidationProvider: RegistrationFormValidatonProviderProtocol,
         reginstrationNetworkProvider: RegistrationNetworkProviderProtocol,
         userDataStore: UserDataStoreServiceProtocol) {
        self.socialViewVM = socialViewVM
        self.formValidationProvider = formValidationProvider
        self.reginstrationNetworkProvider = reginstrationNetworkProvider
        self.userDataStore = userDataStore
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
        
        reginstrationNetworkProvider.register(
            email: registrationData.email,
            password: registrationData.password,
            firstName: registrationData.firstName,
            lastName: registrationData.lastName,
            queue: .main) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success(let user):
                    strongSelf.userDataStore.save(user)
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
