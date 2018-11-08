//
//  API+Login.swift
//  Wallet
//
//  Created by Storiqa on 19/10/2018.
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
        case confirmEmail(token: String)
        case resetPassword(email: String, deviceType: DeviceType)
        case confirmResetPassword(token: String, password: String)
        case socialAuth(oauthToken: String,
            oauthProvider: SocialNetworkTokenProvider,
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
        case .confirmEmail:
            return .post
        case .resetPassword:
            return .post
        case .confirmResetPassword:
            return .post
        case .socialAuth:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "\(Constants.Network.baseUrl)/sessions"
        case .register:
            return "\(Constants.Network.baseUrl)/users"
        case .confirmEmail:
            return "\(Constants.Network.baseUrl)/users/confirm_email"
        case .resetPassword:
            return "\(Constants.Network.baseUrl)/users/reset_password"
        case .confirmResetPassword:
            return "\(Constants.Network.baseUrl)/users/confirm_reset_password"
        case .socialAuth:
            return "\(Constants.Network.baseUrl)/sessions/oauth"
        }
    }
    
    var headers: [String: String] {
        switch self {
<<<<<<< HEAD
        case .login, .register:            
=======
        case .login, .register, .confirmEmail, .resetPassword, .confirmResetPassword, .socialAuth:
>>>>>>> dev
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
        case .confirmEmail(let token):
            return [
                "emailConfirmToken": token
            ]
        case .resetPassword(let email, let deviceType):
            return [
                "email": email,
                "deviceType": deviceType.rawValue
            ]
        case .confirmResetPassword(let token, let password):
            return [
                "token": token,
                "password": password
            ]
        case .socialAuth(let oauthToken, let oauthProvider, let deviceType, let deviceOs, let deviceId):
            return [
                "oauthToken": oauthToken,
                "oauthProvider": oauthProvider.name,
                "deviceType": deviceType.rawValue,
                "deviceOs": deviceOs,
                "deviceId": deviceId
            ]
        }
    }
}
