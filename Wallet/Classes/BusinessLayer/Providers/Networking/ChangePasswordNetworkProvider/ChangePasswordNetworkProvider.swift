//
//  ChangePasswordNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ChangePasswordNetworkProviderProtocol {
    func changePassword(authToken: String,
                        currentPassword: String,
                        newPassword: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<String?>) -> Void)
}

class ChangePasswordNetworkProvider: NetworkLoadable, ChangePasswordNetworkProviderProtocol {
    func changePassword(authToken: String,
                        currentPassword: String,
                        newPassword: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<String?>) -> Void) {
        
        let request = API.Settings.changePassword(authToken: authToken,
                                                  currentPassword: currentPassword,
                                                  newPassword: newPassword,
                                                  signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                
                switch code {
                case 200:
                    completion(.success(nil))
                default:
                    let json = JSON(response.value)
                    let apiError = ChangePasswordNetworkProviderError(code: code, json: json)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// ChangePasswordNetworkErrorParser

enum ChangePasswordNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case internalServer
    case validationError(oldPassword: String?, newPassword: String?)
    case unknownError
    
    init(code: Int, json: JSON) {
        switch code {
        case 401:
            self = .unauthorized
        case 422:
            var oldPasswordMessage: String?
            var newPasswordMessage: String?
            
            if let oldPasswordErrors = json["password"].array {
                oldPasswordMessage = oldPasswordErrors.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
            }
            if let newPasswordErrors = json["new_password"].array {
                newPasswordMessage = newPasswordErrors.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
            }
            
            let hasOldPasswordError = oldPasswordMessage != nil && !oldPasswordMessage!.isEmpty
            let hasNewPasswordError = newPasswordMessage != nil && !newPasswordMessage!.isEmpty
            
            if hasOldPasswordError || hasNewPasswordError {
                self = .validationError(oldPassword: oldPasswordMessage, newPassword: newPasswordMessage)
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
        case .internalServer,
             .unknownError:
            return Constants.Errors.userFriendly
        case .validationError(let oldPassword, let newPassword):
            var result = oldPassword ?? ""
            if let newPassword = newPassword {
                if !result.isEmpty {
                    result += "\n"
                }
                result += newPassword
            }
            
            return result.trim()
        }
    }
}
