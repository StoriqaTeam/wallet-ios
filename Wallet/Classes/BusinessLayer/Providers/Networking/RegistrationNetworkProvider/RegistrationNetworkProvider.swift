//
//  RegistrationNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol RegistrationNetworkProviderProtocol {
    func register(email: String,
                  password: String,
                  firstName: String,
                  lastName: String,
                  queue: DispatchQueue,
                  signHeader: SignHeader,
                  completion: @escaping (Result<User>) -> Void)
}

class RegistrationNetworkProvider: NetworkLoadable, RegistrationNetworkProviderProtocol {
    
    func register(email: String,
                  password: String,
                  firstName: String,
                  lastName: String,
                  queue: DispatchQueue,
                  signHeader: SignHeader,
                  completion: @escaping (Result<User>) -> Void) {
        
        let deviceOs = UIDevice.current.systemVersion
        let deviceType = DeviceType.ios
        
        let request = API.Unauthorized.register(email: email,
                                                password: password,
                                                firstName: firstName,
                                                lastName: lastName,
                                                deviceType: deviceType,
                                                deviceOs: deviceOs,
                                                signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response.value)
                
                if let user = User(json: json) {
                    completion(.success(user))
                } else {
                    let apiError = RegistrationProviderError(code: response.responseStatusCode, json: json)
                    completion(.failure(apiError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


enum RegistrationProviderError: LocalizedError, Error {
    case badRequest
    case unknownError
    case internalServer
    case validationError(email: String?, password: String?)
    
    init(code: Int, json: JSON) {
        switch code {
        case 400:
            self = .badRequest
        case 422:
            var emailMessage: String?
            var passwordMessage: String?
            
            if let emailErrors = json["email"].array {
                emailMessage = emailErrors.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
            }
            if let passwordErrors = json["password"].array {
                passwordMessage = passwordErrors.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
            }
            
            let hasEmailError = emailMessage != nil && !emailMessage!.isEmpty
            let hasPasswordError = passwordMessage != nil && !passwordMessage!.isEmpty
            
            if hasEmailError || hasPasswordError {
                self = .validationError(email: emailMessage, password: passwordMessage)
            } else {
                self = .unknownError
            }
        case 500:
            self = .internalServer
        default:
            self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .internalServer:
            return "Internal server error"
        case .unknownError:
            return Constants.Errors.userFriendly
        case .validationError(let email, let password):
            var result = email ?? ""
            if let password = password {
                if !result.isEmpty {
                    result += "\n"
                }
                result += password
            }
            
            return result.trim()
        }
    }
}
