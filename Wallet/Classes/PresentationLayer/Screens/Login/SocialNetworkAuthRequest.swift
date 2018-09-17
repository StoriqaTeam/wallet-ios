//
//  SocialNetworkAuthRequest.swift
//  Wallet
//
//  Created by user on 24.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class SocialNetworkAuthRequest: Request, GraphQLMutation {
    override var name: String {
        return "getJWTByProvider"
    }
    
    var inputName: String {
        return "CreateJWTProviderInput"
    }
    
    var fields: [String] {
        return ["token"]
    }
    
    convenience init(provider: SocialNetworkTokenProvider, authToken: String) {
        let input: [String: String] = [
            "provider": provider.name,
            "token": authToken
        ]
        
        self.init(input: input)
    }
}
