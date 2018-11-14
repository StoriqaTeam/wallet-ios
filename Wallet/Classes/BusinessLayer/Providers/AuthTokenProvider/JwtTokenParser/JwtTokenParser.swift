//
//  JwtTokenParser.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol JwtTokenParserProtocol {
    func parse(jwtToken: String) -> AuthToken?
}


class JwtTokenParser: JwtTokenParserProtocol {
    
    func parse(jwtToken: String) -> AuthToken? {
        let payloadSubsequence = jwtToken.split(separator: ".")[1]
        let payloadString = String(payloadSubsequence)
        let paddedPayloadString = paddedBase64(encodedString: payloadString)
        if let data = Data(base64Encoded: paddedPayloadString) {
            let jsonPayloud = JSON(data)
            guard let userId = jsonPayloud["user_id"].uInt else { return nil }
            guard let expiredTime = jsonPayloud["exp"].uInt else { return nil }
            return AuthToken(token: jwtToken, userId: userId, expiredTimeStamp: expiredTime)
        }
        
        return nil
    }
}


// MARK: - Private methods

extension JwtTokenParser {
    private func paddedBase64(encodedString: String) -> String {
        guard !(encodedString.count % 4 == 0) else { return encodedString }
        let encodedStringLength = encodedString.count
        let paddedLength = encodedStringLength + (4 - (encodedStringLength % 4))
        let paddedBase64String = encodedString.padding(toLength: paddedLength, withPad: "=", startingAt: 0)
        return paddedBase64String
    }
    
}
