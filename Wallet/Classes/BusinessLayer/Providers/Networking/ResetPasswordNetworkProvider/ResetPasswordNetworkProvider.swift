//
//  ResetPasswordNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ResetPasswordNetworkProviderProtocol {
    func resetPassword(email: String, queue: DispatchQueue, completion: @escaping (Result<String?>) -> Void)
}


class ResetPasswordNetworkProvider: NetworkLoadable, ResetPasswordNetworkProviderProtocol {
    func resetPassword(email: String, queue: DispatchQueue, completion: @escaping (Result<String?>) -> Void) {
        
        let request = API.Unauthorized.resetPassword(email: email, deviceType: .ios)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                switch code {
                case 200:
                    completion(.success(nil))
                default:
                    let apiError = ResetPasswordNetworkProviderError(code: code, json: json)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// EmailNetworkErrorParser

enum ResetPasswordNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case internalServer
    case unknownError
    case sendEmailTimeout
    case emailNotVerified
    
    init(code: Int, json: JSON) {
        switch code {
        case 401:
            self = .unauthorized
        case 422:
            if let deviceErrors = json["email"].array,
                deviceErrors.contains(where: { $0["code"] == "email_timeout" }) {
                self = .sendEmailTimeout
            } else if let deviceErrors = json["email"].array,
                let _ = deviceErrors.first(where: { $0["code"] == "not_verified" }) {
                self = .emailNotVerified
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
        case .sendEmailTimeout:
            return "send_email_timeout".localized()
        case .emailNotVerified:
            return "Email not verified"
        case .unknownError:
            return Constants.Errors.userFriendly
        }
    }
}
