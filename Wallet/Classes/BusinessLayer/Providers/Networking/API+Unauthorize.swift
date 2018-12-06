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
            signHeader: SignHeader)
        case register(email: String,
            password: String,
            firstName: String,
            lastName: String,
            deviceType: DeviceType,
            deviceOs: String,
            signHeader: SignHeader)
        case confirmEmail(token: String)
        case resetPassword(email: String, deviceType: DeviceType)
        case confirmResetPassword(token: String, password: String)
        case socialAuth(oauthToken: String,
            oauthProvider: SocialNetworkTokenProvider,
            deviceType: DeviceType,
            deviceOs: String,
            signHeader: SignHeader)
        case addDevice(userId: Int, deviceOs: String, signHeader: SignHeader)
        case confirmAddDevice(token: String, deviceId: String)
        case resendConfirmEmail(email: String, deviceType: DeviceType)
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
        case .addDevice:
            return .post
        case .confirmAddDevice:
            return .post
        case .resendConfirmEmail:
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
        case .addDevice:
            return "\(Constants.Network.baseUrl)/users/add_device"
        case .confirmAddDevice:
            return "\(Constants.Network.baseUrl)/users/confirm_add_device"
        case .resendConfirmEmail:
            return "\(Constants.Network.baseUrl)/users/resend_confirm_email"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .login(_, _, _, _, let signHeader):
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .register(_, _, _, _, _, _, let signHeader):
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .confirmEmail:
            return [
                "Content-Type": "application/json",
                "accept": "application/json"
            ]
        case .socialAuth(_, _, _, _, let signHeader):
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .resetPassword, .confirmResetPassword:
            return [
                "Content-Type": "application/json",
                "accept": "application/json"
            ]
        case .addDevice(_, _, let signHeader):
            return [
                "Content-Type": "application/json",
                "accept": "application/json",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .confirmAddDevice:
            return [
                "Content-Type": "application/json",
                "accept": "application/json"
            ]
        case .resendConfirmEmail:
            return [
                "Content-Type": "application/json",
                "accept": "application/json"
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .login(let email, let password, let deviceType, let deviceOs, let signHeader):
            return [
                "email": email,
                "password": password,
                "deviceType": deviceType.rawValue,
                "deviceOs": deviceOs,
                "deviceId": signHeader.deviceId
            ]
        case .register(let email, let password, let firstName, let lastName, let deviceType, let deviceOs, let signHeader):
            return [
                "email": email,
                "password": password,
                "firstName": firstName,
                "lastName": lastName,
                "deviceType": deviceType.rawValue,
                "deviceOs": deviceOs,
                "deviceId": signHeader.deviceId,
                "publicKey": signHeader.pubKeyHex
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
        case .socialAuth(let oauthToken, let oauthProvider, let deviceType, let deviceOs, let signerHeader):
            return [
                "oauthToken": oauthToken,
                "oauthProvider": oauthProvider.name,
                "deviceType": deviceType.rawValue,
                "deviceOs": deviceOs,
                "deviceId": signerHeader.deviceId
            ]
        case .addDevice(let userId, let deviceOs, let signHeader):
            return [
                "userId": userId,
                "deviceOs": deviceOs,
                "deviceId": signHeader.deviceId,
                "publicKey": signHeader.pubKeyHex
            ]
        case .confirmAddDevice(let token, let deviceId):
            return [
                "token": token,
                "deviceId": deviceId
            ]
        case .resendConfirmEmail(let email, let deviceType):
            return [
                "email": email,
                "deviceType": deviceType.rawValue
            ]
        }
    }
    
    var unloggedParams: [String]? {
        switch self {
        case .login:
            return ["password"]
        case .register:
            return ["password"]
        case .confirmResetPassword:
            return ["password"]
        default: return nil
        }
    }
}
