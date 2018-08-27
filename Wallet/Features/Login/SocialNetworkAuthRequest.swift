//
//  SocialNetworkAuthRequest.swift
//  Wallet
//
//  Created by user on 24.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum SocialNetworkAuthInput: String, GraphQLMutationInput {
    case provider = "provider"
    case token = "token"
    
    static var name = "CreateJWTProviderInput"
    var fieldCode: String { return self.rawValue }
}

class SocialNetworkAuthRequest: Request, GraphQLMutation {
    typealias Input = SocialNetworkAuthInput
    
    override var name: String {
        return "getJWTByProvider"
    }
    
    var fields: [String] {
        return ["token"]
    }
    
    init(provider: SocialNetworkTokenProvider, authToken: String) {
        super.init()
        
        let input: [String: String] = [
            "clientMutationId": "1", //не используется
            SocialNetworkAuthInput.provider.fieldCode: provider.name,
            SocialNetworkAuthInput.token.fieldCode: authToken
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
