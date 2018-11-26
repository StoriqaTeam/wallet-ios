//
//  AddDeviceNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AddDeviceNetworkProviderProtocol {
    func addDevice(userId: Int,
                   signHeader: SignHeader,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void)
}


class AddDeviceNetworkProvider: NetworkLoadable, AddDeviceNetworkProviderProtocol {
    func addDevice(userId: Int,
                   signHeader: SignHeader,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void) {
        
        let deviceOs = UIDevice.current.systemVersion
        let request = API.Unauthorized.addDevice(userId: userId, deviceOs: deviceOs, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200 else {
                    let error = AddDeviceNetworkProviderError(code: code, json: json)
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
    case deviceAlreadyExists
    case sendEmailTimeout
    
    init(code: Int, json: JSON) {
        switch code {
        case 401:
            self = .unauthorized
        case 422:
            if let deviceErrors = json["device"].array,
                deviceErrors.contains(where: { $0["code"] == "exists" }) {
                self = .deviceAlreadyExists
            } else if let deviceErrors = json["device"].array,
                deviceErrors.contains(where: { $0["code"] == "email_timeout" }) {
                self = .sendEmailTimeout
            } else {
                self = .unknownError
            }
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
        case .deviceAlreadyExists:
            // FIXME: error message
            return "Device already exists"
        case .sendEmailTimeout:
            // FIXME: error message
            return "Can not send email more often then once in 30 seconds"
        case .internalServer, .unknownError:
            return Constants.Errors.userFriendly
        }
    }
}
