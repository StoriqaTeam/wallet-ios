//
//  LoginRequest.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class LoginRequest: Request {
    var name = "getJWTByEmail"
    private var inputName = "CreateJWTEmailInput"
    
    private lazy var query = "mutation \(name)($input: \(inputName)!) { \(name)(input: $input) { token } }"
    
    init(email: String, password: String) {
        super.init()
        
        let input = [
            "clientMutationId": "1", //не используется
            "email": email,
            "password": password
        ]
        
        let variables = [
            "input": input
        ]
        
        let parameters: [String : Any] = [
            "operationName": name,
            "query": query,
            "variables": variables
        ]
        
        self.parameters = parameters
        
    }
}
