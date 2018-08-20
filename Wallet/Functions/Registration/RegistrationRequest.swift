//
//  RegistrationRequest.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class RegistrationRequest: Request {
    var name = "createUser"
    private var inputName = "CreateUserInput"
    
    private lazy var query = "mutation \(name)($input: \(inputName)!) { \(name)(input: $input) { id email firstName } }"
    
    init(firstName: String, lastName: String, email: String, password: String)  {
        super.init()
        
        let input = [
            "clientMutationId": "1", //не используется
            "email": email,
            "password": password,
            "firstName": firstName,
            "lastName": lastName
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
