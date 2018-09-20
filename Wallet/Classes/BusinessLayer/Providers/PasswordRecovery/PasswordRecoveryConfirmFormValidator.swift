//
//  PasswordRecoveryConfirmFormValidator.swift
//  Wallet
//
//  Created by Storiqa on 19.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol PasswordRecoveryConfirmFormValidatorProtocol {
    func formIsValid(newPassword: String?, passwordConfirm: String?) -> (valid: Bool, message: String?)
}

class PasswordRecoveryConfirmFormValidator: PasswordRecoveryConfirmFormValidatorProtocol {
    
    func formIsValid(newPassword: String?, passwordConfirm: String?) -> (valid: Bool, message: String?) {
        guard let newPassword = newPassword,
            let passwordConfirm = passwordConfirm else {
                return (false, nil)
        }
        
        let feildsNonEmpty = !newPassword.isEmpty && !passwordConfirm.isEmpty
    
        if feildsNonEmpty && newPassword != passwordConfirm {
            //TODO: сообщение
            return (false,  "passwords_nonequeal".localized())
        } else {
            return (feildsNonEmpty, nil)
        }
    }
    
}
