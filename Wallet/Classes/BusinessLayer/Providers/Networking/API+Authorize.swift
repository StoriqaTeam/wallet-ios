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
    }
}

extension API.Authorized: APIMethodProtocol {
    var method: HTTPMethod {
        switch self {
        case .user:
            return .get
        case .getAccounts:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .user:
            return "\(Constants.Network.baseUrl)/users/me"
        case .getAccounts(_, let userId):
            // FIXME: разобраться с offset и limit
            return "\(Constants.Network.baseUrl)/users/\(userId)/accounts?offset=0&limit=20"
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
        }
    }
}
