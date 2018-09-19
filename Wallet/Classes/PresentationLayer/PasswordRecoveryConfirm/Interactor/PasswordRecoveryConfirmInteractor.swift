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

    private let formValidator: PasswordRecoveryConfirmFormValidatorProtocol
    
    init(formValidator: PasswordRecoveryConfirmFormValidatorProtocol) {
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
        
        //TODO: implement in new provider
        log.warn("implement resetPassword provider")
        
        // stub
        if arc4random_uniform(2) == 0 {
            output.passwordRecoverySucceed()
        } else {
            output.passwordRecoveryFailed(message: Constants.Errors.userFriendly)
        }
        // ------------------------------
        
    }

}
