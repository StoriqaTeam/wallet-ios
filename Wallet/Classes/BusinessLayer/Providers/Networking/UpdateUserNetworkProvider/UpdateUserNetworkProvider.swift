//
//  UpdateUserNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol UpdateUserNetworkProviderProtocol {
    typealias ResultBlock = (Result<User>) -> Void
    
    func updateUser(authToken: String,
                    firstName: String,
                    lastName: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock)
    func updateUser(authToken: String,
                    phone: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock)
}

class UpdateUserNetworkProvider: NetworkLoadable, UpdateUserNetworkProviderProtocol {
    func updateUser(authToken: String,
                    firstName: String,
                    lastName: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock) {
        
        let request = API.Settings.updateProfile(authToken: authToken, firstName: firstName, lastName: lastName, signHeader: signHeader)
        sendRequest(request: request, queue: queue, completion: completion)
    }
    
    func updateUser(authToken: String,
                    phone: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock) {
        let request = API.Settings.updatePhone(authToken: authToken, phone: phone, signHeader: signHeader)
        sendRequest(request: request, queue: queue, completion: completion)
    }
}


// MARK: - Private methods

extension UpdateUserNetworkProvider {
    func sendRequest(request: API.Settings, queue: DispatchQueue, completion: @escaping (Result<User>) -> Void) {
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                switch code {
                case 200:
                    guard let user = User(json: json) else {
                        let apiError = UpdateUserNetworkProviderError.failToParseJson
                        completion(.failure(apiError))
                        return
                    }
                    
                    completion(.success(user))
                default:
                    let apiError = UpdateUserNetworkProviderError(code: code)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


enum UpdateUserNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case internalServer
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
        case .internalServer,
             .unknownError:
            return Constants.Errors.userFriendly
        case .failToParseJson:
            return "Failed to parse JSON"
        }
    }
}
