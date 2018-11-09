//
//  ExchangeRateNetworkProvider.swift
//  Wallet
//
//  Created by Storiqa on 09/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
// swiftlint:disable all

import Foundation


protocol ExchangeRateNetworkProviderProtocol {
    func getExchangeRate(authToken: String,
                         from: Currency,
                         to: Currency,
                         amountCurrency: Currency,
                         amountInMinUnits: Decimal,
                         queue: DispatchQueue,
                         completion: @escaping (Result<ExchangeRate>) -> Void)
}


class ExchangeRateNetworkProvider: NetworkLoadable, ExchangeRateNetworkProviderProtocol {
    
    
    func getExchangeRate(authToken: String,
                         from: Currency,
                         to: Currency,
                         amountCurrency: Currency,
                         amountInMinUnits: Decimal,
                         queue: DispatchQueue,
                         completion: @escaping (Result<ExchangeRate>) -> Void) {
        
        let id = UUID().uuidString
        let request = API.Rates.getExchangeRate(authToken: authToken,
                                                id: id,
                                                from: from,
                                                to: to,
                                                amountCurrency: amountCurrency,
                                                amountInMinUnits: amountInMinUnits)
        
        loadObjectJSON(request: request, queue: queue) { (result) in
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200 else  {
                    let apiError = ExchangeRateNetworkProviderError(code: code)
                    completion(.failure(apiError))
                    return
                }
                
                guard let exchangeRate = ExchangeRate(json: json) else {
                    let parseError = ExchangeRateNetworkProviderError.parseError
                    completion(.failure(parseError))
                    return
                }
                
                completion(.success(exchangeRate))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


enum ExchangeRateNetworkProviderError: LocalizedError, Error {
    case unauthorized
    case internalServer
    case unknownError
    case parseError
    
    init(code: Int) {
        switch code {
        case 401:
            self = .unauthorized
        case 500:
            self = .internalServer
        default:
            self = .unknownError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unauthorized:
            return "User unauthorized"
        case .internalServer:
            return "Internal server error"
        case .unknownError:
            return Constants.Errors.userFriendly
        case .parseError:
            return "Fail to parse error from server"
        }
    }
}
