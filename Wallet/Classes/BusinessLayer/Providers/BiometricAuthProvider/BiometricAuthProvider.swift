//
//  BiometricAuthProvider.swift
//  Wallet
//
//  Created by Storiqa on 17.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
import Foundation
import LocalAuthentication

enum BiometricAuthType {
    case none
    case touchId
    case faceId
}

protocol BiometricAuthProviderProtocol {
    var canAuthWithBiometry: Bool { get }
    var biometricAuthType: BiometricAuthType { get }
    var biometricAuthImage: UIImage? { get }
    func authWithBiometry(completion: @escaping (Result<String?>) -> Void)
}

class BiometricAuthProvider: BiometricAuthProviderProtocol {
    
    private let context = LAContext()
    
    //FIXME: - localization
    private let touchAuthenticationReason = "Authentication is needed to access your account"//.localized()
    
    var canAuthWithBiometry: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    var biometricAuthType: BiometricAuthType {
        if #available(iOS 11.0, *) {
            switch(context.biometryType) {
            case .faceID:
                return .faceId
            case .touchID:
                return .touchId
            case .none:
                return .none
            }
        } else {
            if canAuthWithBiometry {
                return .touchId
            } else {
                return .none
            }
        }
    }
    
    var biometricAuthImage: UIImage? {
        switch biometricAuthType {
        case .faceId:
            return #imageLiteral(resourceName: "faceid")
        case .touchId:
            return #imageLiteral(resourceName: "touchId")
        default:
            return nil
        }
    }
    
    func authWithBiometry(completion: @escaping (Result<String?>) -> Void) {
        // Hide "Enter Password" button
        context.localizedFallbackTitle = ""
        
        // show the authentication UI
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: touchAuthenticationReason) { (success, error) in
                                if success {
                                    completion(.success(nil))
                                } else {
                                    let error = BiometricAuthProviderError(error: error)
                                    completion(.failure(error))
                                }
        }
    }
}

enum BiometricAuthProviderError: LocalizedError, Error {
    
    case laError(error: LAError)
    case general
    
    init(error: Error?) {
        guard let error = error as? LAError else {
            self = .general
            return
        }
        
        self = .laError(error: error)
    }
    
    var errorDescription: String? {
        switch self {
        case .laError(let error):
            let errorCode = error.code
            
            //TODO: тексты сообщений
            
            switch errorCode {
            case .appCancel:
                return "Authentication was cancelled"
            case .authenticationFailed:
                return "The user failed to provide valid credentials"
            case .passcodeNotSet:
                return "Passcode is not set on the device"
            case .biometryLockout:
                return "Biometry is not available on the device"
            case .biometryNotAvailable:
                 return "TouchID is not available on the device"
            case LAError.invalidContext:
                log.error("The context is invalid: LAContext passed to this call has been previously invalidated.")
                return ""
            default:
                return ""
            }
        default:
            return ""
        }
    }
}
