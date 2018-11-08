//
//  RatesNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RatesNetworkProviderProtocol {
    func getRates(crypto: [String],
                  fiat: [String],
                  queue: DispatchQueue,
                  completion: @escaping (Result<[Rate]>) -> Void )
}


class RatesNetworkProvider: NetworkLoadable, RatesNetworkProviderProtocol {
    func getRates(crypto: [String],
                  fiat: [String],
                  queue: DispatchQueue,
                  completion: @escaping (Result<[Rate]>) -> Void) {
        
        let request = API.Rates.getRates(crypto: crypto, fiat: fiat)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                var rates = [Rate]()
                
                guard code == 200 else {
                    completion(.failure(RatesNetworkProviderError.internalServer))
                    return
                }
                
                guard let ratesDict = json.dictionary else {
                    let apiError = RatesNetworkProviderError.parseError
                    completion(.failure(apiError))
                    return
                }
                
                for (key, value) in ratesDict {
                    guard let rateInfo = value.dictionary else {
                        let apiError = RatesNetworkProviderError.parseError
                        completion(.failure(apiError))
                        return
                    }
                    
                    let newRates = rateInfo.map { Rate(fromISO: key, toISO: $0.key, value: Decimal($0.value.doubleValue)) }
                    rates.append(contentsOf: newRates)
                }
                
                completion(.success(rates))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


enum RatesNetworkProviderError: LocalizedError, Error {
    case parseError
    case internalServer
    
    var errorDescription: String? {
        switch self {
        case .parseError:
            return "Fail to parse rates"
        case .internalServer:
            return "Internal server error"
        }
    }
}
