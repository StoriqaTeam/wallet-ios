//
//  LoginRequest.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum LoginInput: String, GraphQLMutationInput {
    case email = "email"
    case password = "password"
    
    static var name = "CreateJWTEmailInput"
    var fieldCode: String { return self.rawValue }
}


class LoginRequest: Request, GraphQLMutation {
    
    typealias Input = LoginInput
    
    var name: String {
        return "getJWTByEmail"
    }
    var inputName: String {
        return LoginInput.name
    }
    var fields: [String] {
        return ["token"]
    }
    
    init(email: String, password: String) {
        super.init()
        
        let input: [String: String] = [
            "clientMutationId": "1", //не используется
            LoginInput.email.fieldCode: email,
            LoginInput.password.fieldCode: password
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
