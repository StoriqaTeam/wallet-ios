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
                         signHeader: SignHeader,
                         queue: DispatchQueue,
                         completion: @escaping (Result<ExchangeRate>) -> Void)
}


class ExchangeRateNetworkProvider: NetworkLoadable, ExchangeRateNetworkProviderProtocol {
    
    private let networkErrorResolver: NetworkErrorResolverProtocol
    
    init(networkErrorResolverFactory: NetworkErrorResolverFactoryProtocol) {
        self.networkErrorResolver = networkErrorResolverFactory.createSendErrorResolver()
    }
    
    func getExchangeRate(authToken: String,
                         from: Currency,
                         to: Currency,
                         amountCurrency: Currency,
                         amountInMinUnits: Decimal,
                         signHeader: SignHeader,
                         queue: DispatchQueue,
                         completion: @escaping (Result<ExchangeRate>) -> Void) {
        
        let id = UUID().uuidString
        let request = API.Rates.getExchangeRate(authToken: authToken,
                                                id: id,
                                                from: from,
                                                to: to,
                                                amountCurrency: amountCurrency,
                                                amountInMinUnits: amountInMinUnits,
                                                signHeader: signHeader)
        
        loadObjectJSON(request: request, queue: queue) { [weak self] (result) in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let response):
                let code = response.responseStatusCode
                let json = JSON(response.value)
                
                guard code == 200, let exchangeRate = ExchangeRate(json: json) else {
                    let error = strongSelf.networkErrorResolver.resolve(code: code, json: json)
                    completion(.failure(error))
                    return
                }
                
                completion(.success(exchangeRate))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
