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
    var parameters: [String : Any]?
    var headers: HTTPHeaders = [
        "Content-Type": "application/json"
    ]
}

class AuthRequest: Request {
    override init() {
        super.init()
        headers["Authorization"] = "Bearer \(UserInfo.shared.token)"
    }
}

protocol GraphQLMutationInput {
    static var name: String { get }
    var parameterString: String { get }
    
    init?(rawValue: String)
}

extension GraphQLMutationInput {
    
    static func parseErrorMessage(_ message: [String: AnyObject]) -> (GraphQLMutationInput, String)? {
        
        if let code = message["code"] as? String,
            let input = Self.init(rawValue: code),
            let errorMessage = message["message"] as? String {
            return (input, errorMessage)
        } else {
            return nil
        }
    }
}

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
