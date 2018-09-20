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
    
    private let defaultsProvider: DefaultsProviderProtocol
    private let pinValidator: PinValidationProviderProtocol
    private let biometricAuthProvider: BiometricAuthProviderProtocol
    
    init(defaultsProvider: DefaultsProviderProtocol, pinValidator: PinValidationProviderProtocol, biometricAuthProvider: BiometricAuthProviderProtocol) {
        self.defaultsProvider = defaultsProvider
        self.pinValidator = pinValidator
        self.biometricAuthProvider = biometricAuthProvider
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
    
    func isBiometryAuthEnabled() -> Bool {
        return biometricAuthProvider.canAuthWithBiometry && defaultsProvider.isBiometryAuthEnabled
    }
    
}
