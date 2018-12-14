//
//  RefreshTokenNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 12/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RefreshTokenNetworkProviderProtocol {
    func refreshAuthToken(authToken: String,
                          signHeader: SignHeader,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String>) -> Void)
}

class RefreshTokenNetworkProvider: NetworkLoadable, RefreshTokenNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createRefreshErrorResolver()
    }
    
    func refreshAuthToken(authToken: String,
                          signHeader: SignHeader,
                          queue: DispatchQueue,
                          completion: @escaping (Result<String>) -> Void) {
        
        let request = API.Authorized.refreshAuthToken(authToken: authToken, signHeader: signHeader)
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let token = json.string else {
                    let error = self.networkErrorResolver.resolve(code: code, json: json)
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
