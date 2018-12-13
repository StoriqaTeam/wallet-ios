//
//  AddDeviceNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AddDeviceNetworkProviderProtocol {
    func addDevice(userId: Int,
                   signHeader: SignHeader,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void)
}


class AddDeviceNetworkProvider: NetworkLoadable, AddDeviceNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createAddDeviceErrorResolver()
    }
    
    func addDevice(userId: Int,
                   signHeader: SignHeader,
                   queue: DispatchQueue,
                   completion: @escaping (Result<String>) -> Void) {
        
        let deviceOs = UIDevice.current.systemVersion
        let request = API.Unauthorized.addDevice(userId: userId, deviceOs: deviceOs, signHeader: signHeader)
        
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
                
                completion(.success("success"))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
