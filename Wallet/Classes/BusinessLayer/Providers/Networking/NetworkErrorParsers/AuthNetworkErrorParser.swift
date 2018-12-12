//
//  AuthNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class AuthNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        let emailMessage = json["email"].array?.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
        
        let passwordMessage = json["password"].array?.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
        
        
        let hasEmailError = !(emailMessage?.isEmpty ?? true)
        let hasPasswordError = !(passwordMessage?.isEmpty ?? true)
        
        if hasEmailError || hasPasswordError {
            return AuthNetworkError.validationError(email: emailMessage, password: passwordMessage)
        }
        
        return next!.parse(code: code, json: json)
    }
}

enum AuthNetworkError: LocalizedError, Error {
    case validationError(email: String?, password: String?)
    
    var errorDescription: String? {
        return ""
    }
}
