//
//  AccountsNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 23/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsNetworkProviderProtocol {
    func getAccounts(authToken: String,
                     userId: Int,
                     queue: DispatchQueue,
                     signHeader: SignHeader,
                     completion: @escaping (Result<[Account]>) -> Void)
}

class AccountsNetworkProvider: NetworkLoadable, AccountsNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createAccountsErrorResolver()
    }
    
    func getAccounts(authToken: String,
                     userId: Int,
                     queue: DispatchQueue,
                     signHeader: SignHeader,
                     completion: @escaping (Result<[Account]>) -> Void) {
        
        let request = API.Authorized.getAccounts(authToken: authToken, userId: userId, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200,
                    let accounts = json.array?.compactMap({ Account(json: $0) }) else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(accounts))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
