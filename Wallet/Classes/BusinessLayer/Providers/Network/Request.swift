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
    var name: String {
        return ""
    }
    var parameters: [String : Any]
    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
    
    required init(parameters: [String : Any]) {
        self.parameters = parameters
    }
}

class AuthRequest: Request {
    required init(parameters: [String : Any]) {
        super.init(parameters: parameters)
        headers["Authorization"] = "Bearer \(UserInfo.shared.token)"
    }
}
