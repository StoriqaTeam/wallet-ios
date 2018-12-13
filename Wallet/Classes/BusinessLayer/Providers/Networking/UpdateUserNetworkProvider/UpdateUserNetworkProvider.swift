//
//  UpdateUserNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol UpdateUserNetworkProviderProtocol {
    typealias ResultBlock = (Result<User>) -> Void
    
    func updateUser(authToken: String,
                    firstName: String,
                    lastName: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock)
    func updateUser(authToken: String,
                    phone: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock)
}

class UpdateUserNetworkProvider: NetworkLoadable, UpdateUserNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createDefaultErrorResolver()
    }
    
    func updateUser(authToken: String,
                    firstName: String,
                    lastName: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock) {
        
        let request = API.Settings.updateProfile(authToken: authToken, firstName: firstName, lastName: lastName, signHeader: signHeader)
        sendRequest(request: request, queue: queue, completion: completion)
    }
    
    func updateUser(authToken: String,
                    phone: String,
                    queue: DispatchQueue,
                    signHeader: SignHeader,
                    completion: @escaping ResultBlock) {
        let request = API.Settings.updatePhone(authToken: authToken, phone: phone, signHeader: signHeader)
        sendRequest(request: request, queue: queue, completion: completion)
    }
}


// MARK: - Private methods

extension UpdateUserNetworkProvider {
    func sendRequest(request: API.Settings, queue: DispatchQueue, completion: @escaping (Result<User>) -> Void) {
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
