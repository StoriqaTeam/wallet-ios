//
//  SocialAuthNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 06/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol SocialAuthNetworkProviderProtocol {
    func socialAuth(oauthToken: String,
                    oauthProvider: SocialNetworkTokenProvider,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping (Result<String>) -> Void)
}

class SocialAuthNetworkProvider: NetworkLoadable, SocialAuthNetworkProviderProtocol {
    func socialAuth(oauthToken: String,
                    oauthProvider: SocialNetworkTokenProvider,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping (Result<String>) -> Void) {
        

        let deviceOs = UIDevice.current.systemVersion
        let deviceType = DeviceType.ios
        
        let request = API.Unauthorized.socialAuth(oauthToken: oauthToken,
                                                  oauthProvider: oauthProvider,
                                                  deviceType: deviceType,
                                                  deviceOs: deviceOs,
                                                  signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) {(result) in
            switch result {
            case .success(let response):
                let json = JSON(response.value)
                
                if let token = json["token"].string {
                    completion(.success(token))
                } else {
                    let apiError = SocialAuthNetworkProviderError(code: response.responseStatusCode, json: json)
                    completion(.failure(apiError))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
    }
}

// DeviceNetworkErrorParser

enum SocialAuthNetworkProviderError: LocalizedError, Error {
    case badRequest
    case unauthorized
    case unknownError
    case internalServer
    case deviceNotRegistered(userId: Int)
    
    init(code: Int, json: JSON) {
        switch code {
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorized
        case 422:
            guard let deviceErrors = json["device"].array,
                let existsError = deviceErrors.first(where: { $0["code"] == "exists" }),
                let params = existsError["params"].dictionary,
                let userIdStr = params["user_id"]?.string,
                let userId = Int(userIdStr) else {
                    self = .unknownError
                    return
            }
            self = .deviceNotRegistered(userId: userId)
        case 500:
            self = .internalServer
        default:
            self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "User unauthorized"
        case .unknownError, .internalServer:
            return Constants.Errors.userFriendly
        case .deviceNotRegistered:
            return "Device is not registered"
        }
    }
}
