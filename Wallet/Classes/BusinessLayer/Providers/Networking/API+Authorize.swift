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
    }
}

extension API.Authorized: APIMethodProtocol {
    var method: HTTPMethod {
        switch self {
        case .user:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .user:
            return "\(Constants.Network.baseUrl)/users/me"
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .user(let authToken):
            return [
                "Authorization": "Bearer \(authToken)"
            ]
        }
    }
}

