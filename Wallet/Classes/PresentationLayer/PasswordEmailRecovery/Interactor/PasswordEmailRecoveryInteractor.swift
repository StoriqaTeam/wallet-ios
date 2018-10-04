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
    
    private var email: String?
}


// MARK: - PasswordEmailRecoveryInteractorInput

extension PasswordEmailRecoveryInteractor: PasswordEmailRecoveryInteractorInput {
    func resetPassword(email: String) {
        self.email = email
        
        //TODO: implement in new provider
        log.warn("implement resetPassword provider")
        
        // FIXME: - stub
        if Bool.random() {
            output.emailSentSuccessfully()
        } else {
            output.emailSendingFailed(message: Constants.Errors.userFriendly)
        }
        // ------------------------------
    }
    
    func retry() {
        guard let email = email else { fatalError() }
        resetPassword(email: email)
    }
}
