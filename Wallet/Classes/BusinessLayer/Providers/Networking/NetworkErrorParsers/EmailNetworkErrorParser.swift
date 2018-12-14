//
//  EmailNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class EmailNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        if containsError(json: json, key: "email", code: "email_timeout") {
            return EmailNetworkError.sendEmailTimeout
        }
        
        if containsError(json: json, key: "email", code: "not_verified") {
            return EmailNetworkError.emailNotVerified
        }
        
        return next!.parse(code: code, json: json)
    }
}

enum EmailNetworkError: LocalizedError, Error {
    case sendEmailTimeout
    case emailNotVerified
    
    var errorDescription: String? {
        switch self {
        case .sendEmailTimeout:
            return "send_email_timeout".localized()
        case .emailNotVerified:
            return "Email not verified"
        }
    }
}
