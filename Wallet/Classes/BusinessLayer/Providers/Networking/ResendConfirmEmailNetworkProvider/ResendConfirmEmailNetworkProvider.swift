//
//  ResendConfirmEmailNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ResendConfirmEmailNetworkProviderProtocol {
    func confirmAddDevice(email: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void)
}

class ResendConfirmEmailNetworkProvider: NetworkLoadable, ResendConfirmEmailNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createResendConfirmEmailErrorResolver()
    }
    
    func confirmAddDevice(email: String,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String?>) -> Void) {
        let deviceType = DeviceType.ios
        let request = API.Unauthorized.resendConfirmEmail(email: email, deviceType: deviceType)
        
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
