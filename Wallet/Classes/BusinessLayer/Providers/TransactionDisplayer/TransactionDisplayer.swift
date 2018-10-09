//
//  TransactionDisplayer.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionDisplayerProtocol {
    
}


class TransactionDisplayer: TransactionDisplayerProtocol {
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol, converterFactory: CurrecncyConverterFactoryProtocol) {
        self.currencyFormatter = currencyFormatter
        self.converterFactory = converterFactory
    }
    
}
