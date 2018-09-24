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
    
    init(token: String, formValidator: PasswordRecoveryConfirmFormValidatorProtocol) {
        self.token = token
        self.formValidator = formValidator
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
        
        //TODO: implement in new provider
        log.warn("implement resetPassword provider")
        
        // FIXME: - stub
        if arc4random_uniform(2) == 0 {
            output.passwordRecoverySucceed()
        } else {
            output.passwordRecoveryFailed(message: Constants.Errors.userFriendly)
        }
        // ------------------------------
        
    }

    func retry() {
        guard let password = password else { fatalError() }
        confirmReset(newPassword: password)
    }
    
}
