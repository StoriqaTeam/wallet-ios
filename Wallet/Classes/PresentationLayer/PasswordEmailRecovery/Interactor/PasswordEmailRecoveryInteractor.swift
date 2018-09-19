//
//  PasswordEmailRecoveryPasswordEmailRecoveryInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordEmailRecoveryInteractor {
    weak var output: PasswordEmailRecoveryInteractorOutput!
    
    private let formValidator: PasswordEmailRecoveryFormValidatorProtocol
    
    init(formValidator: PasswordEmailRecoveryFormValidatorProtocol) {
        self.formValidator = formValidator
    }
    
}


// MARK: - PasswordEmailRecoveryInteractorInput

extension PasswordEmailRecoveryInteractor: PasswordEmailRecoveryInteractorInput {
    func validateForm(email: String) {
        let isValid = formValidator.emailIsValid(email)
        output.setFormIsValid(isValid)
    }
    
    func resetPassword(email: String) {
        //TODO: implement in new provider
        log.warn("implement resetPassword provider")
        
        // stub
        if arc4random_uniform(2) == 0 {
            output.emailSentSuccessfully()
        } else {
            output.emailSendingFailed(message: Constants.Errors.userFriendly)
        }
        // ------------------------------
    }
}
