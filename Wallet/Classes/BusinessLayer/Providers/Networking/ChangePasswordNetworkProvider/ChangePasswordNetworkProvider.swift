//
//  ChangePasswordNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ChangePasswordNetworkProviderProtocol {
    func changePassword(authToken: String,
                        currentPassword: String,
                        newPassword: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<String?>) -> Void)
}

class ChangePasswordNetworkProvider: NetworkLoadable, ChangePasswordNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createChangePasswordErrorResolver()
    }
    
    func changePassword(authToken: String,
                        currentPassword: String,
                        newPassword: String,
                        queue: DispatchQueue,
                        signHeader: SignHeader,
                        completion: @escaping (Result<String?>) -> Void) {
        
        let request = API.Settings.changePassword(authToken: authToken,
                                                  currentPassword: currentPassword,
                                                  newPassword: newPassword,
                                                  signHeader: signHeader)
        
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
