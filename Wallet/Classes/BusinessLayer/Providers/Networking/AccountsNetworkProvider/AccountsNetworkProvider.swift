//
//  AccountsNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsNetworkProviderProtocol {
    func getAccounts(authToken: String,
                     userId: Int,
                     queue: DispatchQueue,
                     completion: @escaping (Result<[Account]>) -> Void)
}

class AccountsNetworkProvider: NetworkLoadable, AccountsNetworkProviderProtocol {
    
    func getAccounts(authToken: String,
                     userId: Int,
                     queue: DispatchQueue,
                     completion: @escaping (Result<[Account]>) -> Void) {
        
        let request = API.Authorized.getAccounts(authToken: authToken, userId: userId)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response)
                
                if let accountsJson = json.array {
                    let accounts = accountsJson.compactMap { Account(json: $0) }
                    completion(.success(accounts))
                } else {
                    let apiError = AccountsNetworkProviderError(json: json)
                    completion(.failure(apiError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

enum AccountsNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case unknownError
    case internalServer
    
    init(json: JSON) {
        let description = json["description"].stringValue
        
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
        case .unknownError, .internalServer:
            return Constants.Errors.userFriendly
        }
    }
}
