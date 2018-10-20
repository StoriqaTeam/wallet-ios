 //
 //  LoginNetworkProvider.swift
 //  Wallet
 //
 //  Created by Storiqa on 19/10/2018.
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
        
        let request = API.Unauthorized.login(email: email,
                                             password: password,
                                             deviceType: deviceType,
                                             deviceOs: deviceOs,
                                             deviceId: deviceId)
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let json = JSON(response)
                
                if let token = json["token"].string {
                    completion(.success(token))
                } else {
                    let apiError = LoginProviderError(json: json)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                log.debug(error)
                completion(.failure(error))
            }
        }
    }
 }
 
 
 enum LoginProviderError: LocalizedError, Error {
    case badRequest
    case unauthorized
    case unknownError
    
    init(json: JSON) {
        let description = json["description"].stringValue
        
        switch description {
        case "Bad request": self = .badRequest
        case "Unauthorized": self = .unauthorized
        default: self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "User unauthorized"
        case .unknownError:
            return "Unknown error"
        }
    }
 }
