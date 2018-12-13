//
//  ConfirmResetPasswordNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConfirmResetPasswordNetworkProviderProtocol {
    func confirmResetPassword(token: String, password: String, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void)
}


class ConfirmResetPasswordNetworkProvider: NetworkLoadable, ConfirmResetPasswordNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createConfirmResetPasswordErrorResolver()
    }
    
    func confirmResetPassword(token: String, password: String, queue: DispatchQueue, completion: @escaping (Result<String>) -> Void) {
        let request = API.Unauthorized.confirmResetPassword(token: token, password: password)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200,
                    let token = json.string else {
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
