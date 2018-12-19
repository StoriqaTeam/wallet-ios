//
//  CreateAccountNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 02/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable identifier_name

import Foundation

protocol CreateAccountNetworkProviderProtocol {
    func createAccount(authToken: String,
                       userId: Int,
                       id: String,
                       currency: Currency,
                       name: String,
                       queue: DispatchQueue,
                       signHeader: SignHeader,
                       completion: @escaping (Result<Account>) -> Void)
}

class CreateAccountNetworkProvider: NetworkLoadable, CreateAccountNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createDefaultErrorResolver()
    }
    
    func createAccount(authToken: String,
                       userId: Int,
                       id: String,
                       currency: Currency,
                       name: String,
                       queue: DispatchQueue,
                       signHeader: SignHeader,
                       completion: @escaping (Result<Account>) -> Void) {
        let request = API.Authorized.createAccount(
            authToken: authToken,
            userId: userId,
            id: id,
            currency: currency,
            name: name, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let account = Account(json: json) else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(account))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
