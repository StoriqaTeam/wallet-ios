//
//  PasswordInputPasswordInputInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PasswordInputInteractor {
    weak var output: PasswordInputInteractorOutput!
    
    private let pinValidator: PinValidationProviderProtocol
    
    init(pinValidator: PinValidationProviderProtocol) {
        self.pinValidator = pinValidator
    }
}


// MARK: - PasswordInputInteractorInput

extension PasswordInputInteractor: PasswordInputInteractorInput {
    func validatePassword(_ password: String) {
        if pinValidator.pinIsValid(password) {
            output.passwordIsCorrect()
        } else {
            output.passwordIsWrong()
        }
    }
}
