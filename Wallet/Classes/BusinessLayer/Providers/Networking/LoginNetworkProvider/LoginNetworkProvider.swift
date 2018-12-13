//
//  LoginNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 19/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol LoginNetworkProviderProtocol: class {
    func loginUser(email: String,
                   password: String,
                   queue: DispatchQueue,
                   signHeader: SignHeader,
                   completion: @escaping (Result<String>) -> Void)
}


class LoginNetworkProvider: NetworkLoadable, LoginNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createLoginErrorResolver()
    }
    
    func loginUser(email: String,
                   password: String,
                   queue: DispatchQueue,
                   signHeader: SignHeader,
                   completion: @escaping (Result<String>) -> Void) {
        
        let deviceOs = UIDevice.current.systemVersion
        let deviceType = DeviceType.ios
    
        let request = API.Unauthorized.login(email: email,
                                             password: password,
                                             deviceType: deviceType,
                                             deviceOs: deviceOs,
                                             signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let token = json["token"].string else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(token))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
