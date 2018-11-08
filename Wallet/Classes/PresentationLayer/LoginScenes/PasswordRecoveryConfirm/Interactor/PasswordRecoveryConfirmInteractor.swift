//
//  PasswordRecoveryConfirmPasswordRecoveryConfirmInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordRecoveryConfirmInteractor {
    weak var output: PasswordRecoveryConfirmInteractorOutput!

    private var password: String?
    
    private let token: String
    private let formValidator: PasswordRecoveryConfirmFormValidatorProtocol
    private let networkProvider: ConfirmResetPasswordNetworkProviderProtocol
    
    init(token: String,
         formValidator: PasswordRecoveryConfirmFormValidatorProtocol,
         networkProvider: ConfirmResetPasswordNetworkProviderProtocol) {
        self.token = token
        self.formValidator = formValidator
        self.networkProvider = networkProvider
    }
    
}


// MARK: - PasswordRecoveryConfirmInteractorInput

extension PasswordRecoveryConfirmInteractor: PasswordRecoveryConfirmInteractorInput {
    
    func validateForm(newPassword: String?, passwordConfirm: String?) {
        
        let result = formValidator.formIsValid(newPassword: newPassword, passwordConfirm: passwordConfirm)
        output.setFormIsValid(result.valid, passwordsEqualityMessage: result.message)
        
    }
    
    func confirmReset(newPassword: String) {
        self.password = newPassword
        
        networkProvider.confirmResetPassword(token: token, password: newPassword, queue: .main) { [weak self] (result) in
            switch result {
            case .success:
                self?.output.passwordRecoverySucceed()
            case .failure(let error):
                if let error = error as? ConfirmResetPasswordNetworkProviderError {
                    switch error {
                    case .validationError(let password):
                        self?.output.formValidationFailed(password: password)
                        return
                    default: break
                    }
                }
                self?.output.passwordRecoveryFailed(message: error.localizedDescription)
            }
        }
    }

    func retry() {
        guard let password = password else {
            fatalError("trying to retry password confirmation without password")
        }
        confirmReset(newPassword: password)
    }
    
}
