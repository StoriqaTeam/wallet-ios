//
//  API+Settings.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//


import Foundation
import Alamofire


extension API {
    enum Settings {
        case changePassword(authToken: String, currentPassword: String, newPassword: String, signHeader: SignHeader)
        case updateProfile(authToken: String, firstName: String, lastName: String, signHeader: SignHeader)
        case updatePhone(authToken: String, phone: String, signHeader: SignHeader)
    }
}


extension API.Settings: APIMethodProtocol {
    var method: HTTPMethod {
        switch self {
        case .changePassword:
            return .post
        case .updateProfile, .updatePhone:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .changePassword:
            return "\(Constants.Network.baseUrl)/users/change_password"
        case .updateProfile, .updatePhone:
            return "\(Constants.Network.baseUrl)/users"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .changePassword(let authToken, _, _, let signHeader):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .updateProfile(let authToken, _, _, let signHeader):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        case .updatePhone(let authToken, _, let signHeader):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)",
                "Timestamp": signHeader.timestamp,
                "Device-id": signHeader.deviceId,
                "Sign": signHeader.signature
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .changePassword(_, let currentPassword, let newPassword, _):
            return [
                "newPassword": newPassword,
                "oldPassword": currentPassword
            ]
        case .updateProfile(_, let firstName, let lastName, _):
            return [
                "firstName": firstName,
                "lastName": lastName
            ]
        case .updatePhone(_, let phone, _):
            return [
                "phone": phone
            ]
        }
    }
    
    var unloggedParams: [String]? {
        switch self {
        case .changePassword:
            return ["newPassword", "oldPassword"]
        default: return nil
        }
    }
}
