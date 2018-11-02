//
//  CreateAccountNetworkProvider.swift
//  Wallet
//
//  Created by Tata Gri on 02/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable identifier_name

import Foundation

protocol CreateAccountNetworkProviderProtocol {
    func createAccount(authToken: String,
                       userId: Int,
                       id: String,
                       currency: Currency,
                       name: String,
                       queue: DispatchQueue,
                       completion: @escaping (Result<Account>) -> Void)
}

class CreateAccountNetworkProvider: NetworkLoadable, CreateAccountNetworkProviderProtocol {
    func createAccount(authToken: String,
                       userId: Int,
                       id: String,
                       currency: Currency,
                       name: String,
                       queue: DispatchQueue,
                       completion: @escaping (Result<Account>) -> Void) {
        let request = API.Authorized.createAccount(
            authToken: authToken,
            userId: userId,
            id: id,
            currency: currency,
            name: name)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200,
                    let account = Account(json: json) else {
                        let apiError = CreateAccountNetworkProviderError.failToParseJson
                        completion(.failure(apiError))
                        return
                }
                completion(.success(account))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


enum CreateAccountNetworkProviderError: LocalizedError, Error {
    case internalServer
    case unauthorized
    case unknownError
    case failToParseJson
    
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
        case .failToParseJson:
            return "Fail to parse JSON"
        }
    }
}
