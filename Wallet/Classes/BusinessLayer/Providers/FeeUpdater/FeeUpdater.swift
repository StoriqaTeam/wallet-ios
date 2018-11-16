//
//  FeeUpdater.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol FeeUpdaterProtocol {
    func update()
}

class FeeUpdater: FeeUpdaterProtocol {
    private let feeNetworkProvider: FeeNetworkProviderProtocol
    private let feeDataStore: FeeDataStoreServiceProtocol
    private let authTokenProvider: AuthTokenProviderProtocol
    
    private var isUpdating = false
    private var fees = [Fee]()
    
    init(feeNetworkProvider: FeeNetworkProviderProtocol,
         feeDataStore: FeeDataStoreServiceProtocol,
         authTokenProvider: AuthTokenProviderProtocol) {
        self.feeNetworkProvider = feeNetworkProvider
        self.feeDataStore = feeDataStore
        self.authTokenProvider = authTokenProvider
    }
    
    func update() {
        guard !isUpdating else {
            return
        }
        
        isUpdating = true
        
        authTokenProvider.currentAuthToken { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.update(authToken: token)
            case .failure(let error):
                log.warn(error.localizedDescription)
                self?.isUpdating = false
            }
        }
    }
}


extension FeeUpdater {
    private func update(authToken: String) {
        let currencies = [Currency.stq, Currency.eth, Currency.btc]
        
        let combinations: [(from: Currency, to: Currency)] = {
            var res = [(from: Currency, to: Currency)]()
            currencies.forEach {(fromCurrency) in
                for toCurrency in currencies {
                    res.append((fromCurrency, toCurrency))
                }
            }
            return res
        }()
        
        let group = DispatchGroup()
        fees.removeAll()
        
        for pair in combinations {
            group.enter()
            feeNetworkProvider.getFees(
                authToken: authToken,
                fromCurrency: pair.from,
                toCurrency: pair.to,
                queue: .main) { [weak self] (result) in
                    switch result {
                    case .success(let fee):
                        self?.fees.append(fee)
                    case .failure(let error):
                        log.warn(error.localizedDescription)
                    }
                    
                    group.leave()
            }
            
        }
        
        group.notify(queue: .main) {[weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.isUpdating = false
            strongSelf.feeDataStore.save(strongSelf.fees)
        }
    }
}
