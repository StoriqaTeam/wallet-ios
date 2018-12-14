//
//  TransactionsNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 26/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol TransactionsNetworkProviderProtocol {
    func getTransactions(authToken: String, userId: Int, offset: Int, limit: Int,
                         queue: DispatchQueue,
                         signHeader: SignHeader,
                         completion: @escaping (Result<[Transaction]>) -> Void)
}

class TransactionsNetworkProvider: NetworkLoadable, TransactionsNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createDefaultErrorResolver()
    }
    
    func getTransactions(authToken: String, userId: Int, offset: Int, limit: Int,
                         queue: DispatchQueue,
                         signHeader: SignHeader,
                         completion: @escaping (Result<[Transaction]>) -> Void) {
        
        let request = API.Authorized.getTransactions(authToken: authToken,
                                                     userId: userId,
                                                     offset: offset,
                                                     limit: limit,
                                                     signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let txs = json.array?.compactMap({ Transaction(json: $0) }) else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(txs))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
