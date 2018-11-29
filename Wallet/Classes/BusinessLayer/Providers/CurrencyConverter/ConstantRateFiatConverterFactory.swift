//
//  ConstantRateFiatConverterFactory.swift
//  Wallet
//
//  Created by Storiqa on 29/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ConstantRateFiatConverterFactoryProtocol {
    func createConverter(from currency: Currency) -> ConstantRateFiatConverterProtocol
}

class ConstantRateFiatConverterFactory: ConstantRateFiatConverterFactoryProtocol {
    
    private let ratesProvider: RatesProviderProtocol
    
    init(ratesProvider: RatesProviderProtocol) {
        self.ratesProvider = ratesProvider
    }
    
    func createConverter(from currency: Currency) -> ConstantRateFiatConverterProtocol {
        let rate = ratesProvider.getRate(criptoISO: currency.ISO, in: .USD)
        return ConstantRateFiatConverter(rate: rate)
    }
    
}
