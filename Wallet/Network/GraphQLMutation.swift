//
//  GraphQLMutation.swift
//  Wallet
//
//  Created by user on 21.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol GraphQLMutationInput {
    static var name: String { get }
    var fieldCode: String { get }
    
    init?(rawValue: String)
}

protocol GraphQLMutation {
    associatedtype Input: GraphQLMutationInput
    
    var fields: [String] { get }
    var query: String { get }
}

extension GraphQLMutation where Self: Request {
    var query: String {
        let fields = self.fields.reduce("") { return $0 + " " + $1 }
        return "mutation \(name)($input: \(Input.name)!) { \(name)(input: $input) { \(fields) } }"
    }
}
