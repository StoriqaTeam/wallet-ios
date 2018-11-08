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
    private let userStoreService: UserDataStoreServiceProtocol
    
    init(defaultsProvider: DefaultsProviderProtocol,
         pinValidator: PinValidationProviderProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol,
         userStoreService: UserDataStoreServiceProtocol) {
        self.defaultsProvider = defaultsProvider
        self.pinValidator = pinValidator
        self.biometricAuthProvider = biometricAuthProvider
        self.userStoreService = userStoreService
    }
}


// MARK: - PinInputInteractorInput

extension PinInputInteractor: PinInputInteractorInput {
    
    func getCurrentUser() -> User {
        return userStoreService.getCurrentUser()
    }
    
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
        pinValidator.resetPin()
        userStoreService.delete()
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
