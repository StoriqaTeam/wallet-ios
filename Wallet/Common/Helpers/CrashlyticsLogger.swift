//
//  CrashlyticsLogger.swift
//  Wallet
//
//  Created by Storiqa on 06/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation
import Crashlytics


protocol CrashlyticsLogable {
    var unloggedParams: [String]? { get }
    
    func getPath() -> String
    func getParams() -> String
}

extension CrashlyticsLogable where Self: APIMethodProtocol {
    var unloggedParams: [String]? {
        return nil
    }
    
    func getPath() -> String {
        return path
    }
    
    func getParams() -> String {
        guard var params = params else {
            return ""
        }
        
        unloggedParams?.forEach { params[$0] = "***" }
        
        return paramsToString(params)
    }
    
    private func paramsToString(_ params: Params?) -> String {
        guard let params = params else {
            return ""
        }
        
        let result = params.mapValues { return $0 ?? "nil" }
        return result.description
    }
    
}

class CrashlyticsLogger {
    
    static func setUser(_ user: User) {
        Crashlytics.sharedInstance().setUserEmail(user.email)
        Crashlytics.sharedInstance().setUserIdentifier("\(user.id)")
    }
    
    static func networkError<T>(error: Error, request: CrashlyticsLogable, response: @autoclosure () -> T) {
        let userInfo = [
            "request_params": "\(request.getParams())",
            "response": "\(response())"
        ]
        
        Crashlytics.sharedInstance().recordError(error,
                                                 withAdditionalUserInfo: userInfo)
    }
    
    static func error(_ error: Error, message: String) {
        write(string: "|ERROR| " + message)
        Crashlytics.sharedInstance().recordError(error)
    }
    
    static func warn(_ message: String) {
        write(string: "|WARN| " + message)
    }
    
    static func info(_ message: String) {
        write(string: "|INFO| " + message)
    }
    
    static private func write(string: String) {
        CLSLogv("%@", getVaList([string]))
    }
}
