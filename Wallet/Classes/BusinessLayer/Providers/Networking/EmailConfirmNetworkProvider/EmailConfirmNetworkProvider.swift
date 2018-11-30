//
//  EmailConfirmNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol EmailConfirmNetworkProviderProtocol {
    func confirm(token: String,
                 queue: DispatchQueue,
                 completion: @escaping (Result<String>) -> Void)
}

class EmailConfirmNetworkProvider: NetworkLoadable, EmailConfirmNetworkProviderProtocol {
    func confirm(token: String,
                 queue: DispatchQueue,
                 completion: @escaping (Result<String>) -> Void) {
        
        let request = API.Unauthorized.confirmEmail(token: token)
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response.value)
                
                if let token = json.string {
                    completion(.success(token))
                } else {
                    let apiError = EmailConfirmProviderError(code: response.responseStatusCode, json: json)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum EmailConfirmProviderError: LocalizedError, Error {
    case internalServer
    case unauthorized
    case unknownError
    case deviceTokenExpired
    
    init(code: Int, json: JSON) {
        switch code {
        case 401:
            self = .unauthorized
        case 422:
            if let deviceErrors = json["device"].array,
                deviceErrors.contains(where: { $0["code"] == "token" }) {
                self = .deviceTokenExpired
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
        case .deviceTokenExpired:
            // FIXME: error message
            return "Device token expired"
        case .internalServer, .unknownError:
            return Constants.Errors.userFriendly
        }
    }
}
