//
//  API+Login.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 19/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

enum DeviceType: String {
    case ios
    case android
    case web
    case other
}

extension API {
    enum Unauthorized {
        case login(email: String,
            password: String,
            deviceType: DeviceType,
            deviceOs: String,
            deviceId: String)
        case register(email: String,
            password: String,
            firstName: String,
            lastName: String,
            deviceType: DeviceType,
            deviceOs: String,
            deviceId: String)
    }

}


extension API.Unauthorized: APIMethodProtocol {
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .register:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "\(Constants.Network.baseUrl)/sessions"
        case .register:
            return "\(Constants.Network.baseUrl)/users"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .login, .register:            
            return [
                "Content-Type": "application/json",
                "accept": "application/json"
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .login(let email, let password, let deviceType, let deviceOs, let deviceId):
            return [
                "email": email,
                "password": password,
                "deviceType": deviceType.rawValue,
                "deviceOs": deviceOs,
                "deviceId": deviceId
            ]
        case .register(let email, let password, let firstName, let lastName, let deviceType, let deviceOs, let deviceId):
            return [
                "email": email,
                "password": password,
                "firstName": firstName,
                "lastName": lastName,
                "deviceType": deviceType.rawValue,
                "deviceOs": deviceOs,
                "deviceId": deviceId
            ]
        }
    }
}
