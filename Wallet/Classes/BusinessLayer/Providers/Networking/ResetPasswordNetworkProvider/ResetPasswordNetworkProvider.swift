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
                
                switch code {
                case 200:
                    completion(.success(nil))
                default:
                    let apiError = ResetPasswordNetworkProviderError(code: code)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            }
        }
    }
}

enum ResetPasswordNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case internalServer
    case unknownError
    
    init(code: Int) {
        switch code {
        case 401:
            self = .unauthorized
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
        }
    }
}
