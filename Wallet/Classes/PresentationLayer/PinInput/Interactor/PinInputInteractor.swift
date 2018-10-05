//
//  PinInputPasswordInputInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PinInputInteractor {
    weak var output: PinInputInteractorOutput!
    
    private let defaultsProvider: DefaultsProviderProtocol
    private let pinValidator: PinValidationProviderProtocol
    private let biometricAuthProvider: BiometricAuthProviderProtocol
    
    init(defaultsProvider: DefaultsProviderProtocol, pinValidator: PinValidationProviderProtocol, biometricAuthProvider: BiometricAuthProviderProtocol) {
        self.defaultsProvider = defaultsProvider
        self.pinValidator = pinValidator
        self.biometricAuthProvider = biometricAuthProvider
    }
}


// MARK: - PinInputInteractorInput

extension PinInputInteractor: PinInputInteractorInput {
    
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
    
    func resetPin() {
        defaultsProvider.isQuickLaunchShown = false
        pinValidator.resetPin()
    }
    
    func biometricAuthImage() -> UIImage? {
        return biometricAuthProvider.biometricAuthImage
    }
    
    func authWithBiometry() {
        biometricAuthProvider.authWithBiometry { [weak self] (success, errorMessage) in
            DispatchQueue.main.async {
                if success {
                    self?.output.touchAuthenticationSucceed()
                } else {
                    self?.output.touchAuthenticationFailed(error: errorMessage)
                }
            }
        }
    }
    
}
