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
                          deviceId: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void)
    
}

class ConfirmAddDeviceNetworkProvider: NetworkLoadable, ConfirmAddDeviceNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createConfirmAddDeviceErrorResolver()
    }
    
    
    func confirmAddDevice(deviceConfirmToken: String,
                          deviceId: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void) {
        let request = API.Unauthorized.confirmAddDevice(token: deviceConfirmToken, deviceId: deviceId)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200 else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
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
