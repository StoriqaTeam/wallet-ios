//
//  RefreshTokenNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RefreshTokenNetworkProviderProtocol {
    func refreshAuthToken(authToken: String,
                          signHeader: SignHeader,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String>) -> Void)
}

class RefreshTokenNetworkProvider: NetworkLoadable, RefreshTokenNetworkProviderProtocol {
    
    func refreshAuthToken(authToken: String,
                          signHeader: SignHeader,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String>) -> Void) {
        
        let request = API.Authorized.refreshAuthToken(authToken: authToken, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let token = json.string else {
                    let error = RefreshTokenNetworkProviderError(code: code)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(token))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum RefreshTokenNetworkProviderError: LocalizedError, Error {
    case unknownError
    case internalServer
    case unauthorized
    
    init(code: Int) {
        switch code {
        case 401: self = .unauthorized
        case 500: self = .internalServer
        default: self = .unknownError
        }
    }
    
    var errorDescription: String? {
        return Constants.Errors.userFriendly
    }
}
