//
//  FeeNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol FeeNetworkProviderProtocol {
    func getFees(authToken: String,
                 currency: Currency,
                 accountAddress: String,
                 signHeader: SignHeader,
                 queue: DispatchQueue,
                 completion: @escaping (Result<[EstimatedFee]>) -> Void)
}

class FeeNetworkProvider: NetworkLoadable, FeeNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createSendErrorResolver()
    }
    
    func getFees(authToken: String,
                 currency: Currency,
                 accountAddress: String,
                 signHeader: SignHeader,
                 queue: DispatchQueue,
                 completion: @escaping (Result<[EstimatedFee]>) -> Void) {
        let request = API.Fees.getFees(authToken: authToken, currency: currency, accountAddress: accountAddress, signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200,
                    let fees = json["fees"].array?.compactMap({ EstimatedFee(json: $0, currency: currency) }),
                    !fees.isEmpty else {
                        let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                        completion(.failure(error))
                        return
                }
                
                completion(.success(fees))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
