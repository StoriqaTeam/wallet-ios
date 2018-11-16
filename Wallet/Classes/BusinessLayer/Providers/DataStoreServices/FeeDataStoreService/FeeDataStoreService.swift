//
//  FeeDataStoreService.swift
//  Wallet
//
//  Created by Storiqa on 16/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol FeeDataStoreServiceProtocol {
    func save(_ models: [Fee])
    func getFees() -> [Fee]
    
    func observe(updateHandler: @escaping ([Fee]) -> Void)
}

class FeeDataStoreService: RealmStorable<Fee>, FeeDataStoreServiceProtocol {
    func getFees() -> [Fee] {
        return find()
    }
}
