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
    private let appLockerProvider: AppLockerProviderProtocol
    
    init(defaultsProvider: DefaultsProviderProtocol,
         pinValidator: PinValidationProviderProtocol,
         biometricAuthProvider: BiometricAuthProviderProtocol,
         userStoreService: UserDataStoreServiceProtocol,
         appLockerProvider: AppLockerProviderProtocol) {
        self.defaultsProvider = defaultsProvider
        self.pinValidator = pinValidator
        self.biometricAuthProvider = biometricAuthProvider
        self.userStoreService = userStoreService
        self.appLockerProvider = appLockerProvider
    }
}


// MARK: - PinInputInteractorInput

extension PinInputInteractor: PinInputInteractorInput {
    func setIsLocked() {
        appLockerProvider.setIsLocked(true)
    }
    
    func getCurrentUser() -> User {
        return userStoreService.getCurrentUser()
    }
    
    func validatePassword(_ password: String) {
        if pinValidator.pinIsValid(password) {
            output.passwordIsCorrect()
            appLockerProvider.setIsLocked(false)
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
        appLockerProvider.setIsLocked(false)
    }
    
    func biometricAuthImage() -> UIImage? {
        return biometricAuthProvider.biometricAuthImage
    }
    
    func authWithBiometry() {
        biometricAuthProvider.authWithBiometry { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.output.touchAuthenticationSucceed()
                    self?.appLockerProvider.setIsLocked(false)
                case .failure(let error):
                    self?.output.touchAuthenticationFailed(error: error.localizedDescription)
                }
            }
        }
    }
    
}
