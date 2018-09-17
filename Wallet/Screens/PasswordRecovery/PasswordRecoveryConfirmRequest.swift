//
//  PasswordRecoveryConfirmRequest.swift
//  Wallet
//
//  Created by user on 14.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class PasswordRecoveryConfirmRequest: Request, GraphQLMutation {
    override var name: String {
        return "applyPasswordReset"
    }
    
    var inputName: String {
        return "ResetApply"
    }
    
    var fields: [String] {
        return ["success"]
    }
    
    convenience init(token: String, password: String) {
        let input: [String: String] = [
            "token": token,
            "password": password
        ]
        
        self.init(input: input)
    }
}
