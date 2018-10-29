//
//  API+Authorize.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

extension API {
    enum Authorized {
        case user(authToken: String)
        case getAccounts(authToken: String, userId: Int)
        case getTransactions(authToken: String, userId: Int, offset: Int, limit: Int)
        case resetPassword(authToken: String, email: String, deviceType: DeviceType)
    }
}

extension API.Authorized: APIMethodProtocol {
    var method: HTTPMethod {
        switch self {
        case .user:
            return .get
        case .getAccounts:
            return .get
        case .getTransactions:
            return .get
        case .resetPassword:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .user:
            return "\(Constants.Network.baseUrl)/users/me"
        case .getAccounts(_, let userId):
            // FIXME: разобраться с offset и limit!!!
            return "\(Constants.Network.baseUrl)/users/\(userId)/accounts?offset=0&limit=20"
        case .getTransactions(_, let userId, let offset, let limit):
            return "\(Constants.Network.baseUrl)/users/\(userId)/transactions?offset=\(offset)&limit=\(limit)"
        case .resetPassword:
            return "\(Constants.Network.baseUrl)/users/reset_password"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .user(let authToken):
            return [
                "Authorization": "Bearer \(authToken)"
            ]
        case .getAccounts(let authToken, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        case .getTransactions(let authToken, _, _, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        case .resetPassword(let authToken, _, _):
            return [
                "accept": "application/json",
                "Authorization": "Bearer \(authToken)"
            ]
        }
    }
    
    var params: Params? {
        switch self {
        case .getAccounts:
            return nil
        case .user:
            return nil
        case .getTransactions:
            return nil
        case .resetPassword(_, let email, let deviceType):
            return [
                "email": email,
                "deviceType": deviceType.rawValue
            ]
        }
    }
}
