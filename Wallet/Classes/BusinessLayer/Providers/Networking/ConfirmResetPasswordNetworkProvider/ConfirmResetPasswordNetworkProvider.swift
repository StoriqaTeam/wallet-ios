//
//  ConfirmResetPasswordNetworkProvider.swift
//  Wallet
//
//  Created by Tata Gri on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConfirmResetPasswordNetworkProviderProtocol {
    func confirmResetPassword(token: String, password: String, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void)
}


class ConfirmResetPasswordNetworkProvider: NetworkLoadable, ConfirmResetPasswordNetworkProviderProtocol {
    
    func confirmResetPassword(token: String, password: String, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void) {
        let request = API.Unauthorized.confirmResetPassword(token: token, password: password)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                if code == 200,
                    let token = json.string {
                    completion(.success(token))
                } else {
                    let apiError = ConfirmResetPasswordNetworkProviderError(code: response.responseStatusCode, json: json)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            }
        }
    }
}


enum ConfirmResetPasswordNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case internalServer
    case unknownError
    case validationError(password: String?)
    
    init(code: Int, json: JSON) {
        switch code {
        case 401:
            self = .unauthorized
        case 422:
            var passwordMessage: String?
        
            if let passwordErrors = json["password"].array {
                passwordMessage = passwordErrors.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
            }
        
            if passwordMessage != nil && !passwordMessage!.isEmpty {
                self = .validationError(password: passwordMessage)
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
        case .unauthorized:
            return "User unauthorized"
        case .internalServer:
            return "Internal server error"
        case .unknownError:
            return Constants.Errors.userFriendly
        case .validationError(let password):
            var result = ""
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
