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
    func authWithBiometry(completion: @escaping ((Bool, String?) -> Void))
}

class BiometricAuthProvider: BiometricAuthProviderProtocol {
    
    private let errorParser: BiometricAuthErrorParserProtocol
    private let context = LAContext()
    
    //FIXME: - localization
    private let touchAuthenticationReason = "Authentication is needed to access your account"//.localized()
    
    init(errorParser: BiometricAuthErrorParserProtocol) {
        self.errorParser = errorParser
    }
    
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
    
    func authWithBiometry(completion: @escaping ((Bool, String?) -> Void)) {
        // Hide "Enter Password" button
        context.localizedFallbackTitle = ""
        
        // show the authentication UI
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: touchAuthenticationReason) {[weak self] (success, error) in
            completion(success, self?.errorParser.errorMessageForLAErrorCode(error: error))
        }
    }
}
