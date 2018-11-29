//
//  ConfirmAddDeviceNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConfirmAddDeviceNetworkProviderProtocol {
    func confirmAddDevice(deviceConfirmToken: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void)
    
}

class ConfirmAddDeviceNetworkProvider: NetworkLoadable, ConfirmAddDeviceNetworkProviderProtocol {
    
    func confirmAddDevice(deviceConfirmToken: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void) {
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let request = API.Unauthorized.confirmAddDevice(token: deviceConfirmToken, deviceId: deviceId)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200 else {
                    let error = ConfirmAddDeviceNetworkProviderError(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum ConfirmAddDeviceNetworkProviderError: Error, LocalizedError {
    case badRequest
    case unauthorized
    case unknownError
    case internalServer
    case deviceTokenExpired
    case deviceDiffers
    
    init(code: Int, json: JSON) {
        switch code {
        case 400: self = .badRequest
        case 401: self = .unauthorized
        case 422:
            if let deviceErrors = json["device"].array,
                deviceErrors.contains(where: { $0["code"] == "token" }) {
                self = .deviceTokenExpired
            } else if let deviceErrors = json["device"].array,
                deviceErrors.contains(where: { $0["code"] == "device_id" }) {
                self = .deviceDiffers
            } else {
                self = .unknownError
            }
        case 500: self = .internalServer
        default: self = .unknownError
        }
    }
    
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "User unauthorized"
        case .deviceTokenExpired:
            // FIXME: error message
            return "Device token expired"
        case .deviceDiffers:
            // FIXME: error message
            return "Confirmed device differs from your device"
        case .internalServer, .unknownError:
            return Constants.Errors.userFriendly
        }
    }
}
