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
    
    private let tokenExpiredChannelOutput: TokenExpiredChannel
    
    init(tokenExpiredChannelOutput: TokenExpiredChannel) {
        self.tokenExpiredChannelOutput = tokenExpiredChannelOutput
    }
    
    func parse(code: Int, json: JSON) -> Error {
        // FIXME: проверить
        if containsError(json: json, key: "token", code: "revoked") {
            tokenExpiredChannelOutput.send(true)
            return TokenRevokeNetworkError.tokenRevoked
        }
        
        if containsError(json: json, key: "token", code: "expired") {
            tokenExpiredChannelOutput.send(true)
            return TokenRevokeNetworkError.tokenExpired
        }
        
        return next!.parse(code: code, json: json)
    }
}


enum TokenRevokeNetworkError: LocalizedError, Error {
    case tokenRevoked
    case tokenExpired
    
    var errorDescription: String? {
        switch self {
        case .tokenRevoked:
            return "Your session was finished. Please sign in again."
        case .tokenExpired:
            return "Your session was expired. Please sign in again."
        }
    }
    
}
