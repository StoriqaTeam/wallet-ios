//
//  RegistrationNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol RegistrationNetworkProviderProtocol {
    func register(email: String,
                  password: String,
                  firstName: String,
                  lastName: String,
                  queue: DispatchQueue,
                  completion: @escaping (Result<User>) -> Void)
}

class RegistrationNetworkProvider: NetworkLoadable, RegistrationNetworkProviderProtocol {
    
    func register(email: String,
                  password: String,
                  firstName: String,
                  lastName: String,
                  queue: DispatchQueue,
                  completion: @escaping (Result<User>) -> Void) {
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let deviceOs = UIDevice.current.systemVersion
        let deviceType = DeviceType.ios
        
        let request = API.Unauthorized.register(email: email,
                                                password: password,
                                                firstName: firstName,
                                                lastName: lastName,
                                                deviceType: deviceType,
                                                deviceOs: deviceOs,
                                                deviceId: deviceId)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response)
                
                if let user = User(json: json) {
                    completion(.success(user))
                } else {
                    let apiError = RegistrationProviderError(json: json)
                    completion(.failure(apiError))
                }
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            }
        }
    }
}


enum RegistrationProviderError: LocalizedError, Error {
    case badRequest
    case unknownError
    case internalServer
    case invalidEmail
    case invalidPassword
    
    init(json: JSON) {
        if let description = json["description"].string {
            switch description {
            case "Bad request": self = .badRequest
            case "Internal server erro": self = .internalServer
            default: self = .unknownError
            }
        } else {
            // FIXME: parse validation error
            self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .internalServer:
            return "Internal server error"
        case .unknownError,
             .invalidEmail,
             .invalidPassword:
            return Constants.Errors.userFriendly
        }
    }
}
