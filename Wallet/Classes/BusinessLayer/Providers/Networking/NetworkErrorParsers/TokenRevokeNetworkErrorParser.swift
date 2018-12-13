//
//  TokenRevokeNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class TokenRevokeNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        // FIXME: проверить
        if containsError(json: json, key: "token", code: "revoked") {
            return TokenRevokeNetworkError()
        }
        
        return next!.parse(code: code, json: json)
    }
}


struct TokenRevokeNetworkError: LocalizedError, Error {
    var errorDescription: String? {
        // FIXME: msg token revoked
        return "Your session was finished. Please sign in again."
    }
}
