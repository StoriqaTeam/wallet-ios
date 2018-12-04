//
//  ResendConfirmEmailNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ResendConfirmEmailNetworkProviderProtocol {
    func confirmAddDevice(email: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void)
}

class ResendConfirmEmailNetworkProvider: NetworkLoadable, ResendConfirmEmailNetworkProviderProtocol {
    func confirmAddDevice(email: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void) {
        let deviceType = DeviceType.ios
        let request = API.Unauthorized.resendConfirmEmail(email: email, deviceType: deviceType)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200 else {
                    let error = ResendConfirmEmailNetworkProviderError(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum ResendConfirmEmailNetworkProviderError: Error, LocalizedError {
    case badRequest
    case unauthorized
    case unknownError
    case internalServer
    case sendEmailTimeout
    
    init(code: Int, json: JSON) {
        switch code {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 422:
            if let deviceErrors = json["email"].array,
                deviceErrors.contains(where: { $0["code"] == "email_timeout" }) {
                self = .sendEmailTimeout
            } else {
                self = .unknownError
            }
        case 500: self = .internalServer
        default: self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "User unauthorized"
        case .sendEmailTimeout:
            // FIXME: msg error message
            return "Can not send email more often then once in 30 seconds"
        case .badRequest, .internalServer, .unknownError:
            return Constants.Errors.userFriendly
        }
    }
}
