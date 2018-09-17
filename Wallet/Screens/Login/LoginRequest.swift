//
//  LoginRequest.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class LoginRequest: Request, GraphQLMutation {
    
    override var name: String {
        return "getJWTByEmail"
    }
    
    var inputName: String {
        return "CreateJWTEmailInput"
    }
    
    var fields: [String] {
        return ["token"]
    }
    
    convenience init(email: String, password: String) {
        let input: [String: String] = [
            "email": email,
            "password": password
            ]
        
        self.init(input: input)
    }
}
