//
//  RegistrationRequest.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum RegistrationInput: String, GraphQLMutationInput {
    case firstName
    case lastName
    case email
    case password
    
    static var name = "CreateUserInput"
    var fieldCode: String { return self.rawValue }
}

class RegistrationRequest: Request, GraphQLMutation {
    typealias Input = RegistrationInput
    
    var name: String {
        return "createUser"
    }
    
    var fields: [String] {
        return ["id", "email", "firstName"]
    }
    
    init(firstName: String, lastName: String, email: String, password: String)  {
        super.init()
        
        let input: [String: String] = [
            "clientMutationId": "1", //не используется
            RegistrationInput.email.fieldCode: email,
            RegistrationInput.password.fieldCode: password,
            RegistrationInput.firstName.fieldCode: firstName,
            RegistrationInput.lastName.fieldCode: lastName
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
