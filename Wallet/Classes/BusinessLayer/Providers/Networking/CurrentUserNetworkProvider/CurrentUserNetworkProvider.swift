//
//  CurrentUserNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrentUserNetworkProviderProtocol {
    func getCurrentUser(authToken: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<User>) -> Void)
}


class CurrentUserNetworkProvider: NetworkLoadable, CurrentUserNetworkProviderProtocol {
    
    func getCurrentUser(authToken: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<User>) -> Void) {
        
        let request = API.Authorized.user(authToken: authToken, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response.value)
                
                if let user = User(json: json) {
                    completion(.success(user))
                } else {
                    let apiError = CurrentUserNetworkProviderError(code: response.responseStatusCode)
                    completion(.failure(apiError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum CurrentUserNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case unknownError
    case internalServer
    
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
        case .unknownError, .internalServer:
            return Constants.Errors.userFriendly
        }
    }
}
