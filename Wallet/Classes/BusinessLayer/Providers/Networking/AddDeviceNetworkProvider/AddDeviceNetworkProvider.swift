//
//  AddDeviceNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AddDeviceNetworkProviderProtocol {
    func addDevice(email: String,
                   password: String,
                   signHeader: SignHeader,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void)
}


class AddDeviceNetworkProvider: NetworkLoadable, AddDeviceNetworkProviderProtocol {
    func addDevice(email: String,
                   password: String,
                   signHeader: SignHeader,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void) {
        
        let request = API.Unauthorized.addDevice(email: email, password: password, deviceOs: .ios, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                
                guard code == 200 else {
                    let error = AddDeviceNetworkProviderError(code: code)
                    completion(.failure(error))
                    return
                }
                
                completion(.success("success"))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}


enum AddDeviceNetworkProviderError: Error, LocalizedError {
    case internalServer
    case unauthorized
    case unknownError
    
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
        }
    }
}
