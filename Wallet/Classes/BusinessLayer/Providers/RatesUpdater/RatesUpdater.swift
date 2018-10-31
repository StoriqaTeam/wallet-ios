//
//  RatesUpdater.swift
//  Wallet
//
//  Created by Даниил Мирошниченко on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RatesUpdaterProtocol {
    func update()
}


class RatesUpdater: RatesUpdaterProtocol {
    
    private let ratesDataStoreService: RatesDataStoreServiceProtocol
    private let ratesNetworkProvider: RatesNetworkProviderProtocol
    
    private var isUpdating = false
    
    init(ratesDataSourceService: RatesDataStoreServiceProtocol, ratesNetworkProvider: RatesNetworkProviderProtocol) {
        self.ratesDataStoreService = ratesDataSourceService
        self.ratesNetworkProvider = ratesNetworkProvider
    }
    
    func update() {
        guard !isUpdating else {
            return
        }
        
        isUpdating = true
        
        ratesNetworkProvider.getRates(crypto: Constants.Currencies.defaultCryptoCurrencies,
                                      fiat: Constants.Currencies.defaultFiatCurrencies,
                                      queue: .main) { [weak self] (result) in
                                        guard let strongSelf = self else {
                                            return
                                        }
        
                                        switch result {
                                        case .success(let rates):
                                            log.info("Success update rates")
                                            strongSelf.ratesDataStoreService.save(rates: rates)
                                            self?.isUpdating = false
                                        case .failure(let error):
                                            log.error(error.localizedDescription)
                                            self?.isUpdating = false
                                        }
        }
    }
    
    
}
