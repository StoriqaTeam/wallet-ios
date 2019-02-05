//
//  TransactionMapper.swift
//  Wallet
//
//  Created by Storiqa on 09/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionMapperProtocol {
    func map(from obj: Transaction, account: Account) -> TransactionDisplayable
    func map(from objs: [Transaction], account: Account, completion: @escaping (([TransactionDisplayable]) -> Void))
}

class TransactionMapper: TransactionMapperProtocol {
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let transactionDirectionResolver: TransactionDirectionResolverProtocol
    private let transactionOpponentResolver: TransactionOpponentResolverProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         transactionDirectionResolver: TransactionDirectionResolverProtocol,
         transactionOpponentResolver: TransactionOpponentResolverProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.currencyFormatter = currencyFormatter
        self.transactionDirectionResolver = transactionDirectionResolver
        self.transactionOpponentResolver = transactionOpponentResolver
        self.denominationUnitsConverter = denominationUnitsConverter
    }
    
    func map(from objs: [Transaction], account: Account, completion: @escaping (([TransactionDisplayable]) -> Void)) {
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
            let result = objs.map { (obj) -> TransactionDisplayable in
                return strongSelf.map(from: obj, account: account)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    func map(from obj: Transaction, account: Account) -> TransactionDisplayable {
        let direction = transactionDirectionResolver.resolveDirection(for: obj, account: account)
        let opponent = transactionOpponentResolver.resolveOpponent(for: obj, account: account)
        let timestamp = date(from: obj)
        
        let currency = account.currency
        let amountInMinUnits: Decimal
        let amountPrefix: String
        
        switch direction {
        case .send:
            amountInMinUnits = obj.fromValue
            amountPrefix = "-"
        case .receive:
            amountInMinUnits = obj.toValue
            amountPrefix = "+"
        }
        
        let cryptoAmountDecimal = denominationUnitsConverter.amountToMaxUnits(amountInMinUnits, currency: currency)
        let feeAmountDecimal = denominationUnitsConverter.amountToMaxUnits(obj.fee, currency: obj.fromCurrency)
        
        let cryptoAmountString = amountPrefix + " " +
            currencyFormatter.getStringFrom(amount: cryptoAmountDecimal, currency: currency)
        let feeAmountString = currencyFormatter.getStringFrom(amount: feeAmountDecimal, currency: currency)
        let secondAmountString = getSecondAmount(from: obj, direction: direction, amountPrefix: amountPrefix)
        
        return TransactionDisplayable(transaction: obj,
                                      cryptoAmountString: cryptoAmountString,
                                      currency: currency,
                                      secondAmountString: secondAmountString,
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
    
    private func getSecondAmount(from obj: Transaction, direction: Direction, amountPrefix: String) -> String {
        let secondAmountString: String
        
        if let fiatAmount = obj.fiatValue, let fiatCurrency = obj.fiatCurrency, !fiatAmount.decimalValue().isZero {
            let fiatAmoutDecimal = fiatAmount.decimalValue()
            secondAmountString = amountPrefix +
                currencyFormatter.getStringFrom(amount: fiatAmoutDecimal, currency: fiatCurrency)
            
        } else if obj.fromCurrency != obj.toCurrency {
            let opponentAmount: Decimal
            let opponentCurrency: Currency
            let opponentAmountPrefix: String
            
            switch direction {
            case .send:
                opponentAmount = obj.toValue
                opponentCurrency = obj.toCurrency
                opponentAmountPrefix = "+"
            case .receive:
                opponentAmount = obj.fromValue
                opponentCurrency = obj.fromCurrency
                opponentAmountPrefix = "-"
            }
            let opponentAmountInMaxUnits = denominationUnitsConverter.amountToMaxUnits(opponentAmount, currency: opponentCurrency)
            secondAmountString = opponentAmountPrefix +
                currencyFormatter.getStringFrom(amount: opponentAmountInMaxUnits, currency: opponentCurrency)
            
        } else {
            secondAmountString = ""
        }
        
        return secondAmountString
    }
}
