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
                 fromCurrency: Currency,
                 toCurrency: Currency,
                 queue: DispatchQueue,
                 completion: @escaping (Result<Fee>) -> Void)
}

class FeeNetworkProvider: NetworkLoadable, FeeNetworkProviderProtocol {
    func getFees(authToken: String,
                 fromCurrency: Currency,
                 toCurrency: Currency,
                 queue: DispatchQueue,
                 completion: @escaping (Result<Fee>) -> Void) {
        let request = API.Fees.getFees(authToken: authToken,
                                       fromCurrency: fromCurrency,
                                       toCurrency: toCurrency)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                
                guard code == 200 else {
                    let error = FeeNetworkProviderError(code: code)
                    completion(.failure(error))
                    return
                }
                
                let json = JSON(response.value)
                
                guard let fee = Fee(json: json, fromCurrency: fromCurrency, toCurrency: toCurrency) else {
                    let error = FeeNetworkProviderError.parseJsonError
                    completion(.failure(error))
                    return
                }
                completion(.success(fee))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum FeeNetworkProviderError: LocalizedError, Error {
    case unknownError
    case internalServer
    case parseJsonError
    
    init(code: Int) {
        switch code {
        case 500:
            self = .internalServer
        default:
            self = .unknownError
        }
    }
    
    var errorDescription: String? {
        return Constants.Errors.userFriendly
    }
}
