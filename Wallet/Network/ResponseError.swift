//
//  ResponseError.swift
//  Wallet
//
//  Created by user on 17.08.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case API = 100      // microservice responded, but with error http status. In this case `details` is guaranteed to have `status` field with http status and probably some additional details.
    case network = 200  // there was a network error while connecting to microservice.
    case parse = 300    // there was a parse error - that usually means that graphql couldn't parse api json response (probably because of mismatching types on graphql and microservice) or api url parse failed.
    case unknown = 400  // unknown error.
}

class ResponseError {
    let code: ErrorCode
    
    init(code: ErrorCode) {
        self.code = code
    }
    
    static func parseError(_ dict: [String: AnyObject]) -> ResponseError? {
        guard let data = dict["data"] as? [String: AnyObject],
            let codeData = data["code"] as? Int,
            let code = ErrorCode(rawValue: codeData),
            let details = data["details"] else {
                return nil
        }
        
        switch code {
        case .API where details is [String: AnyObject]:
            if let details = details as? [String: AnyObject],
                let error = ResponseAPIError(details) {
                return error
            }
        case .network where details is String,
             .parse where details is String,
             .unknown where details is String:
            if let details = details as? String,
                let error = ResponseDefaultError(details, code: code) {
                return error
            }
        default:
            break
        }
        return nil
    }
}

class ResponseAPIError: ResponseError {
    let status: String
    let message: [String: AnyObject]?
    
    init?(_ details: [String: AnyObject]) {
        guard let status = details["status"] as? String,
            let messageData = (details["message"] as? String)?.data(using: String.Encoding.utf8),
            let messageJson = try? JSONSerialization.jsonObject(with: messageData, options: []) as? [String: AnyObject],
            let message = messageJson else {
                return nil
        }
        
        self.status = status
        self.message = message
        
        super.init(code: ErrorCode.API)
    }
}

class ResponseDefaultError: ResponseError {
    let details: String
    
    init?(_ details: String, code: ErrorCode) {
        self.details = details
        super.init(code: code)
    }
}
