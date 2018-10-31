//
//  RatesDataStoreService.swift
//  Wallet
//
//  Created by Storiqa on 31/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol RatesDataStoreServiceProtocol {
    func save(rates: [Rate])
    func getRates(cryptoCurrency: String) -> [Rate]
    
    func observe(updateHandler: @escaping ([Rate]) -> Void)
}


class RatesDataStoreService: RealmStorable<Rate>, RatesDataStoreServiceProtocol {
    
    func save(rates: [Rate]) {
        save(rates)
    }
    
    func getRates(cryptoCurrency: String) -> [Rate] {
        return find().filter { $0.fromISO == cryptoCurrency }
    }
}
