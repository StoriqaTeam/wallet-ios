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
    private let loginService: LoginServiceProtocol
    private let biometricAuthProvider: BiometricAuthProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let userKeyManager: UserKeyManagerProtocol
    
    init(socialViewVM: SocialNetworkAuthViewModel,
         formValidationProvider: RegistrationFormValidatonProviderProtocol,
         registrationNetworkProvider: RegistrationNetworkProviderProtocol,
         loginService: LoginServiceProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         userKeyManager: UserKeyManagerProtocol) {
        
        self.socialViewVM = socialViewVM
        self.formValidationProvider = formValidationProvider
        self.registrationNetworkProvider = registrationNetworkProvider
        self.loginService = loginService
        self.biometricAuthProvider = biometricAuthProvider
        self.signHeaderFactory = signHeaderFactory
        self.userKeyManager = userKeyManager
        
    }
    
}


// MARK: - RegistrationInteractorInput

extension RegistrationInteractor: RegistrationInteractorInput {
    
    func getSocialVM() -> SocialNetworkAuthViewModel {
        return socialViewVM
    }
    
    func validateForm(_ form: RegistrationForm) {
        let valid = formValidationProvider.formIsValid(form)
        output.setFormIsValid(valid)
    }
    
    func register(with registrationData: RegistrationData) {
        self.registrationData = registrationData
        
        guard let _ = userKeyManager.addPrivateKeyIfNeeded(email: registrationData.email) else {
            log.error("Fail to add pair email and private key")
            return
        }
        
        let signHeader: SignHeader
        do {
            signHeader = try signHeaderFactory.createSignHeader(email: registrationData.email)
        } catch {
            log.error(error.localizedDescription)
            return
        }
        
        registrationNetworkProvider.register(
            email: registrationData.email,
            password: registrationData.password,
            firstName: registrationData.firstName,
            lastName: registrationData.lastName,
            queue: .main,
            signHeader: signHeader) { [weak self] (result) in
                guard let strongSelf = self else {
                    return
                }
                
                switch result {
                case .success:
                    strongSelf.output.registrationSucceed(email: registrationData.email)
                case .failure(let error):
                    if let error = error as? RegistrationProviderError {
                        switch error {
                        case .validationError(let email, let password):
                            strongSelf.output.formValidationFailed(email: email, password: password)
                            return
                        default: break
                        }
                    }
                    
                    strongSelf.output.registrationFailed(message: error.localizedDescription)
                }
        }
    }
    
    func signIn(tokenProvider: SocialNetworkTokenProvider, oauthToken: String, email: String) {
        guard let _ = userKeyManager.addPrivateKeyIfNeeded(email: email) else {
            log.error("Fail to add pair email and private key")
            return
        }
    
        loginService.signIn(tokenProvider: tokenProvider, oauthToken: oauthToken, email: email) { [weak self] (result) in
            switch result {
            case .success:
                self?.socialAuthSucceed()
            case .failure(let error):
                self?.output.socialAuthFailed(message: error.localizedDescription)
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


// MARK: - Private methods

extension RegistrationInteractor {
    private func socialAuthSucceed() {
        if biometricAuthProvider.canAuthWithBiometry {
            output.showQuickLaunch()
        } else {
            output.showPinQuickLaunch()
        }
    }
}
