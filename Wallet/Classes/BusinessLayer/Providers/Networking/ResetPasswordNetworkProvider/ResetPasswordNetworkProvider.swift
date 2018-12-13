//
//  ResetPasswordNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 29/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ResetPasswordNetworkProviderProtocol {
    func resetPassword(email: String, queue: DispatchQueue, completion: @escaping (Result<String?>) -> Void)
}


class ResetPasswordNetworkProvider: NetworkLoadable, ResetPasswordNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createResetPasswordErrorResolver()
    }
    
    func resetPassword(email: String, queue: DispatchQueue, completion: @escaping (Result<String?>) -> Void) {
        
        let request = API.Unauthorized.resetPassword(email: email, deviceType: .ios)
        
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
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
