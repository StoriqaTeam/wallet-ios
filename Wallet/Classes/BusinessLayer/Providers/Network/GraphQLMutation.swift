//
//  GraphQLMutation.swift
//  Wallet
//
//  Created by Storiqa on 21.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol GraphQLMutation {
    var fields: [String] { get }
    var query: String { get }
    var inputName: String { get }
}

extension GraphQLMutation where Self: Request {
    var query: String {
        let fields = self.fields.reduce("") { return $0 + " " + $1 }
        return "mutation \(name)($input: \(inputName)!) { \(name)(input: $input) { \(fields) } }"
    }
    
    init(input: [String: String]) {
        var input = input
        input["clientMutationId"] = ""
        
        let variables = [
            "input": input
        ]
    
        self.init(parameters: [:])
        
        
        let parameters: [String : Any] = [
            "operationName": name,
            "query": query,
            "variables": variables
        ]
        
        self.parameters = parameters
    }
}
