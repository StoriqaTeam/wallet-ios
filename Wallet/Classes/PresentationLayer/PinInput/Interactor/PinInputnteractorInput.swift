//
//  PinInputPasswordInputInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PinInputInteractorInput: class {
    func validatePassword(_ password: String)
    func isBiometryAuthEnabled() -> Bool
    func biometricAuthImage() -> UIImage?
    func authWithBiometry()
    func resetPin()
    func getCurrentUser() -> User
}
