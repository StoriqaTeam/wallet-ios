//
//  CurrentUserNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 20/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol CurrentUserNetworkProviderProtocol {
    func getCurrentUser(authToken: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<User>) -> Void)
}


class CurrentUserNetworkProvider: NetworkLoadable, CurrentUserNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createDefaultErrorResolver()
    }
    
    func getCurrentUser(authToken: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<User>) -> Void) {
        
        let request = API.Authorized.user(authToken: authToken, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let user = User(json: json) else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(user))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
