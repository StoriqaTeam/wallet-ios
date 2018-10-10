//
//  TransactionMapper.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionMapper: Mappable {
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let transactionDirectionResolver: TransactionDirectionResolverProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol,
         transactionDirectionResolver: TransactionDirectionResolverProtocol) {
        
        self.currencyFormatter = currencyFormatter
        self.converterFactory = converterFactory
        self.transactionDirectionResolver = transactionDirectionResolver
    }
    
    func map(from obj: Transaction) -> TransactionDisplayable {
        let cryptoAmountDecimal = obj.cryptoAmount
        let currency = obj.currency
        let converter = converterFactory.createConverter(from: currency)
        let fiatAmoutDecimal = converter.convert(amount: cryptoAmountDecimal, to: .fiat)
        
        let cryptoAmountString = currencyFormatter.getStringFrom(amount: cryptoAmountDecimal, currency: currency)
        let fiatAmountString = currencyFormatter.getStringFrom(amount: fiatAmoutDecimal, currency: .fiat)
        let direction = transactionDirectionResolver.resolveDirection(for: obj)
    
        // FIXME: OpponentResolver that will work with contact
        let opponent = OpponentType.address(address: "MOCK MOCK MOCK")
        
        return TransactionDisplayable(transaction: obj,
                                      cryptoAmountString: cryptoAmountString,
                                      fiatAmountString: fiatAmountString,
                                      direction: direction,
                                      opponent: opponent)
    }
}
