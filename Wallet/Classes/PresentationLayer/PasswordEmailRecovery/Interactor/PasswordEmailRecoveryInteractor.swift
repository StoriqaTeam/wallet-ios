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
    
}


// MARK: - PasswordEmailRecoveryInteractorInput

extension PasswordEmailRecoveryInteractor: PasswordEmailRecoveryInteractorInput {
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
