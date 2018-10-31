//
//  TransactionMapper.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionMapper: Mappable {
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrencyConverterFactoryProtocol
    private let transactionDirectionResolver: TransactionDirectionResolverProtocol
    private let transactionOpponentResolver: TransactionOpponentResolverProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         transactionDirectionResolver: TransactionDirectionResolverProtocol,
         transactionOpponentResolver: TransactionOpponentResolverProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.currencyFormatter = currencyFormatter
        self.converterFactory = converterFactory
        self.transactionDirectionResolver = transactionDirectionResolver
        self.transactionOpponentResolver = transactionOpponentResolver
        self.denominationUnitsConverter = denominationUnitsConverter
    }
    
    func map(from obj: Transaction) -> TransactionDisplayable {
        
        let currency = obj.currency
        let cryptoAmountDecimal = denominationUnitsConverter.amountToMaxUnits(obj.cryptoAmount, currency: currency)
        let feeAmountDecimal = denominationUnitsConverter.amountToMaxUnits(obj.fee, currency: currency)
        
        let converter = converterFactory.createConverter(from: currency)
        let fiatAmoutDecimal = converter.convert(amount: cryptoAmountDecimal, to: .fiat)
        
        let cryptoAmountString = currencyFormatter.getStringFrom(amount: cryptoAmountDecimal, currency: currency)
        let feeAmountString = currencyFormatter.getStringFrom(amount: feeAmountDecimal, currency: currency)
        let fiatAmountString = currencyFormatter.getStringFrom(amount: fiatAmoutDecimal, currency: .fiat)
        let direction = transactionDirectionResolver.resolveDirection(for: obj)
        let opponent = transactionOpponentResolver.resolveOpponent(for: obj)
        let timestamp = date(from: obj)
        
        return TransactionDisplayable(transaction: obj,
                                      cryptoAmountString: cryptoAmountString,
                                      fiatAmountString: fiatAmountString,
                                      direction: direction,
                                      opponent: opponent,
                                      feeAmountString: feeAmountString,
                                      timestamp: timestamp)
    }
}


// MARK: Private methods

extension TransactionMapper {
    private func date(from transaction: Transaction) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let timestamp = transaction.createdAt
        return dateFormatter.string(from: timestamp)
    }
}
