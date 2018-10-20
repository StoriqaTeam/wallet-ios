//
//  LoginNetworkProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 19/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol LoginNetworkProviderProtocol: class {
    func loginUser(email: String,
                   password: String,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void)
}


class LoginNetworkProvider: NetworkLoadable, LoginNetworkProviderProtocol {
    func loginUser(email: String,
                   password: String,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void) {
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let deviceOs = UIDevice.current.systemVersion
        let deviceType = DeviceType.ios
        
        loadObjectJSON(request: API.Unauthorized.login(email: email, password: password, deviceType: deviceType, deviceOs: deviceOs, deviceId: deviceId), queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response)
                
                if let token = json["token"].string {
                    completion(.success(token))
                }
                
                let description = json["description"].stringValue
                var apiError: LoginProviderError
                
                switch description {
                case "Bad request": apiError = .badRequest
                case "Unauthorized": apiError = .unauthorized
                default: apiError = .unknownError
                }
                
                completion(.failure(apiError))
    
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            }
        }
    }
}


enum LoginProviderError: LocalizedError {
    case badRequest
    case unauthorized
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "User unauthorized"
        case .unknownError:
            return "Onknown error"
        }
    }
}


