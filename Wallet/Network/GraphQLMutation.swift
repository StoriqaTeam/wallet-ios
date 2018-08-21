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

//extension GraphQLMutationInput {
//    static func parseErrorMessage(_ message: ResponseAPIError.Message) -> (GraphQLMutationInput, String)? {
//        
//        if let input = Self.init(rawValue: message.code) {
//            return (input, message.message)
//        } else {
//            return nil
//        }
//    }
//}

protocol GraphQLMutation {
    associatedtype Input: GraphQLMutationInput
    
    var name: String { get }
    var fields: [String] { get }
    var query: String { get }
}

extension GraphQLMutation {
    var query: String {
        let fields = self.fields.reduce("") { return $0 + " " + $1 }
        return "mutation \(name)($input: \(Input.name)!) { \(name)(input: $input) { \(fields) } }"
    }
}
