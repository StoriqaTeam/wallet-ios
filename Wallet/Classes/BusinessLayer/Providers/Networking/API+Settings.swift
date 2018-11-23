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
        case updateUser(authToken: String, user: User, signHeader: SignHeader)
    }
}


extension API.Settings: APIMethodProtocol {
    var method: HTTPMethod {
        switch self {
        case .changePassword:
            return .post
        case .updateUser:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .changePassword:
            return "\(Constants.Network.baseUrl)/users/change_password"
        case .updateUser:
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
        case .updateUser(let authToken, _, let signHeader):
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
        case .updateUser(_, let user, _):
            return [
                "firstName": user.firstName,
                "lastName": user.lastName,
                "phone": user.phone
            ]
        }
    }
}
