//
//  ExchangeRatesLoader.swift
//  Wallet
//
//  Created by Storiqa on 21/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//
//swiftlint:disable identifier_name

import Foundation


protocol ExchangeRatesLoaderProtocol {
    func getExchangeRates(from: Currency,
                          to: Currency,
                          amountCurrency: Currency,
                          amountInMinUnits: Decimal,
                          completion: @escaping (Result<ExchangeRate>) -> Void)
}


class ExchangeRatesLoader: ExchangeRatesLoaderProtocol {
    
    private let userDataStore: UserDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    private let signHeaderFactory: SignHeaderFactoryProtocol
    private let exchangeRatesNetworkProvider: ExchangeRateNetworkProviderProtocol
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    
    init(userDataStore: UserDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol,
         signHeaderFactory: SignHeaderFactoryProtocol,
         exchangeRatesNetworkProvider: ExchangeRateNetworkProviderProtocol) {
        
        self.userDataStore = userDataStore
        self.authTokenProvider = authTokenProvider
        self.signHeaderFactory = signHeaderFactory
        self.exchangeRatesNetworkProvider = exchangeRatesNetworkProvider
    }
    
    func getExchangeRates(from: Currency,
                          to: Currency,
                          amountCurrency: Currency,
                          amountInMinUnits: Decimal,
                          completion: @escaping (Result<ExchangeRate>) -> Void) {
        
        pendingRequestWorkItem?.cancel()
        
        let requestWorkItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else { return }
            
            let currentEmail = strongSelf.userDataStore.getCurrentUser().email
            let signHeader: SignHeader
            do {
                signHeader = try strongSelf.signHeaderFactory.createSignHeader(email: currentEmail)
            } catch {
                log.error(error.localizedDescription)
                return
            }
            
            self?.authTokenProvider.currentAuthToken { [weak self] (result) in
                switch result {
                case .success(let token):
                    self?.getExchangeRates(authToken: token,
                                                from: from,
                                                to: to,
                                                amountCurrency: amountCurrency,
                                                amountInMinUnits: amountInMinUnits,
                                                signHeader: signHeader,
                                                completion: completion)
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: requestWorkItem)
    }
}


// MARK: - Private methods

extension ExchangeRatesLoader {
    
    private func getExchangeRates(authToken: String,
                                  from: Currency,
                                  to: Currency,
                                  amountCurrency: Currency,
                                  amountInMinUnits: Decimal,
                                  signHeader: SignHeader,
                                  completion: @escaping (Result<ExchangeRate>) -> Void) {
        exchangeRatesNetworkProvider.getExchangeRate(authToken: authToken,
                                                     from: from,
                                                     to: to, amountCurrency: amountCurrency,
                                                     amountInMinUnits: amountInMinUnits,
                                                     signHeader: signHeader,
                                                     queue: .main,
                                                     completion: completion)
    }
}
