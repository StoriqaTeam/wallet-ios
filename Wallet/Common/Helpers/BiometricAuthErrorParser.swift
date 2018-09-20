//
//  BiometricAuthErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 23.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import LocalAuthentication


//FIXME: rename file after fixing project tree
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
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed:
            message = "The user failed to provide valid credentials"
            
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable:
            message = "TouchID is not available on the device"
            
        case LAError.invalidContext:
            print("The context is invalid: LAContext passed to this call has been previously invalidated.")
            return nil
            
        case LAError.userFallback,
             LAError.userCancel:
            return nil
            
        default:
            if #available(iOS 11.0, *),
                errorCode == LAError.biometryNotAvailable {
                message = "Biometry is not available on the device"
            } else {
                return nil
            }
        }
        
        return message
        
    }
}


