//
//  ConfirmResetPasswordErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ConfirmResetPasswordErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        let passwordMessage = json["password"].array?.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
        
        if !(passwordMessage?.isEmpty ?? true) {
            return ConfirmResetPasswordNetworkError(password: passwordMessage)
        }
        
        return next!.parse(code: code, json: json)
    }
}

struct ConfirmResetPasswordNetworkError: LocalizedError, Error {
    let password: String?
    
    var errorDescription: String? {
        return ""
    }
}
