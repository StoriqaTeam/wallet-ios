//
//  ChangePasswordNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ChangePasswordNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        
        let oldPasswordMessage = json["password"].array?.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
        let newPasswordMessage = json["new_password"].array?.compactMap { $0["message"].string }.reduce("", { $0 + " " + $1 }).trim()
        
        let hasOldPasswordError = !(oldPasswordMessage?.isEmpty ?? true)
        let hasNewPasswordError = !(newPasswordMessage?.isEmpty ?? true)
        
        if hasOldPasswordError || hasNewPasswordError {
            return ChangePasswordNetworkError.validationError(oldPassword: oldPasswordMessage, newPassword: newPasswordMessage)
        }
        
        return next!.parse(code: code, json: json)
    }
}

enum ChangePasswordNetworkError: LocalizedError, Error {
    case validationError(oldPassword: String?, newPassword: String?)
    
    var errorDescription: String? {
        return ""
    }
}
