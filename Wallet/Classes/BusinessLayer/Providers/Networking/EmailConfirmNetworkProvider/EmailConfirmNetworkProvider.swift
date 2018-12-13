//
//  EmailConfirmNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol EmailConfirmNetworkProviderProtocol {
    func confirm(token: String,
                 queue: DispatchQueue,
                 completion: @escaping (Result<String>) -> Void)
}

class EmailConfirmNetworkProvider: NetworkLoadable, EmailConfirmNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createEmailConfirmErrorResolver()
    }
    
    func confirm(token: String,
                 queue: DispatchQueue,
                 completion: @escaping (Result<String>) -> Void) {
        
        let request = API.Unauthorized.confirmEmail(token: token)
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let token = json.string else {
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
