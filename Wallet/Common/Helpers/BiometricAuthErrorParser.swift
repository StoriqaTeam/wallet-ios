//
//  BiometricAuthErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 23.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import LocalAuthentication


protocol BiometricAuthErrorParserProtocol {
    func errorMessageForLAErrorCode(error: Error?) -> String?
}

class BiometricAuthErrorParser: BiometricAuthErrorParserProtocol {
    func errorMessageForLAErrorCode(error: Error?) -> String? {
        
        guard let error = error as? LAError else {
            return nil
        }
        
        let errorCode = error.code
        
        //TODO: тексты сообщений
        
        var message: String?
        
        switch errorCode {
        case LAError.appCancel:
            message = "Authentication was cancelled"
        case LAError.authenticationFailed:
            message = "The user failed to provide valid credentials"
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device"
        case LAError.systemCancel:
            message = "Authentication was cancelled by the system"
        case LAError.biometryLockout:
            message = "Biometry is not available on the device"
        case LAError.biometryNotAvailable:
            message = "TouchID is not available on the device"
        case LAError.invalidContext:
            log.error("The context is invalid: LAContext passed to this call has been previously invalidated.")
            return nil
        default:
            return nil
        }
        
        return message
        
    }
}
