//
//  CurrentUserNetworkProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrentUserNetworkProviderProtocol {
    func getCurrentUser(authToken: String,
                        queue: DispatchQueue,
                        completion: @escaping (Result<User>) -> Void)
}


class CurrentUserNetworkProvider: NetworkLoadable, CurrentUserNetworkProviderProtocol {
    
    func getCurrentUser(authToken: String,
                        queue: DispatchQueue,
                        completion: @escaping (Result<User>) -> Void) {
        
        let request = API.Authorized.user(authToken: authToken)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response)
                
                if let user = User(json: json) {
                    completion(.success(user))
                } else {
                    let apiError = CurrentUserNetworkProviderError(json: json)
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
    
    init(json: JSON) {
        let description = json["description"].stringValue
        
        switch description {
        case "Unauthorized": self = .unauthorized
        default: self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "User unauthorized"
        case .unknownError:
            return Constants.Errors.userFriendly
        }
    }
}
