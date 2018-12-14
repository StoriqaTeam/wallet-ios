//
//  DeviceNetworkErrorParser.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class DeviceNetworkErrorParser: NetworkErrorParserProtocol {
    var next: NetworkErrorParserProtocol?
    
    func parse(code: Int, json: JSON) -> Error {
        if containsError(json: json, key: "device", code: "token") {
            return DeviceNetworkError.deviceTokenExpired
        }
        
        if containsError(json: json, key: "device", code: "device_id") {
            return DeviceNetworkError.deviceDiffers
        }
        
        if let deviceErrors = json["device"].array,
            let existsError = deviceErrors.first(where: { $0["code"] == "exists" }) {
            if let params = existsError["params"].dictionary,
                let userIdStr = params["user_id"]?.string,
                let userId = Int(userIdStr) {
                return DeviceNetworkError.deviceNotRegistered(userId: userId)
            }
            
            return DeviceNetworkError.deviceAlreadyExists
        }
        
        return next!.parse(code: code, json: json)
            
    }
}

enum DeviceNetworkError: LocalizedError, Error {
    case deviceTokenExpired
    case deviceDiffers
    case deviceAlreadyExists
    case deviceNotRegistered(userId: Int)
    
    var errorDescription: String? {
        switch self {
        case .deviceTokenExpired:
            return "device_token_expired".localized()
        case .deviceDiffers:
            return "This device differs from the one with which you’ve requested confirmation."
        case .deviceAlreadyExists:
            return "This device is already confirmed"
        case .deviceNotRegistered:
            return "Device is not registered"
        }
    }
}
