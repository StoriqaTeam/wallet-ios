//
//  Request.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Alamofire

class Request {
    var parameters: [String : Any]?
    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
}

class AuthRequest: Request {
    override init() {
        super.init()
        headers["Authorization"] = "Bearer \(UserInfo.shared.token)"
    }
}
