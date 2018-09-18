//
//  RegistrationRequest.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class RegistrationRequest: Request, GraphQLMutation {
    override var name: String {
        return "createUser"
    }
    
    var inputName: String {
        return "CreateUserInput"
    }
    
    var fields: [String] {
        return ["id", "email", "firstName"]
    }
    
    convenience init(firstName: String, lastName: String, email: String, password: String)  {
        let input: [String: String] = [
            "email": email,
            "password": password,
            "firstName": firstName,
            "lastName": lastName
            ]
        
        self.init(input: input)
    }
}
