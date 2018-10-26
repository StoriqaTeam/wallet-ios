//
//  EmailConfirmNetworkProvider.swift
//  Wallet
//
//  Created by Tata Gri on 25/10/2018.
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
                let json = JSON(response)
                
                if let token = json.string {
                    completion(.success(token))
                } else {
                    let apiError = EmailConfirmProviderError(json: json)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            }
        }
    }
}

enum EmailConfirmProviderError: LocalizedError, Error {
    case internalServer
    case unauthorized
    case unknownError
    
    init(json: JSON) {
        guard let description = json["description"].string else {
            self = .unknownError
            return
        }
        
        switch description {
        case "Unauthorized": self = .unauthorized
        case "Internal server error": self = .internalServer
        default: self = .unknownError
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
