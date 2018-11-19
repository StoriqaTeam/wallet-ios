//
//  ConfirmAddDeviceNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConfirmAddDeviceNetworkProviderProtocol {
    func confirmAddDevice(signHeader: SignHeader, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void )
    
}

class ConfirmAddDeviceNetworkProvider: NetworkLoadable, ConfirmAddDeviceNetworkProviderProtocol {
    
    func confirmAddDevice(signHeader: SignHeader, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void ) {
        
        let request = API.Unauthorized.confirmAddDevice(signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.responseStatusCode)
                
                guard code == 200 else {
                    let error = ConfirmAddDeviceNetworkProviderError(code: code)
                    completion(.failure(error))
                    return
                }
                
                guard let deviceToken = json["deviceConfirmToken"].string else {
                    let error = ConfirmAddDeviceNetworkProviderError.parceError
                    completion(.failure(error))
                    return
                }
                
                completion(.success(deviceToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum ConfirmAddDeviceNetworkProviderError: Error, LocalizedError {
    case badRequest
    case unauthorized
    case unknownError
    case internalServer
    case parceError
    
    init(code: Int) {
        switch code {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 500: self = .internalServer
        default: self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "User unauthorized"
        case .parceError:
            return "Fail to parse response from server"
        case .internalServer, .unknownError:
            return Constants.Errors.userFriendly
        }
    }
}
