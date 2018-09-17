//
//  PasswordRecoveryRequest.swift
//  Wallet
//
//  Created by user on 14.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryRequest: Request, GraphQLMutation {
    override var name: String {
        return "requestPasswordReset"
    }
    
    var inputName: String {
        return "ResetRequest"
    }
    
    var fields: [String] {
        return ["success"]
    }
    
    convenience init(email: String) {
        let input: [String: String] = [
            "email": email
        ]
        
        self.init(input: input)
    }
}
