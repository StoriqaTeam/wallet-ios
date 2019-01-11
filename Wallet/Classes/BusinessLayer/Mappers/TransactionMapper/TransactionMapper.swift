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
        
        let currency = account.currency
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            
            let result = objs.map { (obj) -> TransactionDisplayable in
                let direction = strongSelf.transactionDirectionResolver.resolveDirection(for: obj, account: account)
                let opponent = strongSelf.transactionOpponentResolver.resolveOpponent(for: obj, account: account)
                let timestamp = strongSelf.date(from: obj)
                
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
                
                let cryptoAmountDecimal = strongSelf.denominationUnitsConverter.amountToMaxUnits(amountInMinUnits, currency: currency)
                let feeAmountDecimal = strongSelf.denominationUnitsConverter.amountToMaxUnits(obj.fee, currency: obj.fromCurrency)
                
                let cryptoAmountString = amountPrefix + " " +
                    strongSelf.currencyFormatter.getStringFrom(amount: cryptoAmountDecimal, currency: currency)
                let feeAmountString = strongSelf.currencyFormatter.getStringFrom(amount: feeAmountDecimal, currency: currency)
                
                let fiatAmountString: String
                if let fiatAmount = obj.fiatValue, let fiatCurrency = obj.fiatCurrency {
                    let fiatAmoutDecimal = fiatAmount.decimalValue()
                    fiatAmountString = amountPrefix +
                        strongSelf.currencyFormatter.getStringFrom(amount: fiatAmoutDecimal, currency: fiatCurrency)
                } else {
                    fiatAmountString = ""
                }
                
                return TransactionDisplayable(transaction: obj,
                                              cryptoAmountString: cryptoAmountString,
                                              currency: currency,
                                              fiatAmountString: fiatAmountString,
                                              direction: direction,
                                              opponent: opponent,
                                              feeAmountString: feeAmountString,
                                              timestamp: timestamp)
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
        
        let currency: Currency
        let amountInMinUnits: Decimal
        let amountPrefix: String
        
        switch direction {
        case .send:
            currency = obj.fromCurrency
            amountInMinUnits = obj.fromValue
            amountPrefix = "-"
        case .receive:
            currency = obj.toCurrency
            amountInMinUnits = obj.toValue
            amountPrefix = "+"
        }
        
        let cryptoAmountDecimal = denominationUnitsConverter.amountToMaxUnits(amountInMinUnits, currency: currency)
        let feeAmountDecimal = denominationUnitsConverter.amountToMaxUnits(obj.fee, currency: obj.fromCurrency)
        
        let cryptoAmountString = amountPrefix + " " +
            currencyFormatter.getStringFrom(amount: cryptoAmountDecimal, currency: currency)
        let feeAmountString = currencyFormatter.getStringFrom(amount: feeAmountDecimal, currency: currency)
        
        let fiatAmountString: String
        if let fiatAmount = obj.fiatValue, let fiatCurrency = obj.fiatCurrency {
            let fiatAmoutDecimal = fiatAmount.decimalValue()
            fiatAmountString = amountPrefix +
                currencyFormatter.getStringFrom(amount: fiatAmoutDecimal, currency: fiatCurrency)
        } else {
            fiatAmountString = ""
        }
        
        return TransactionDisplayable(transaction: obj,
                                      cryptoAmountString: cryptoAmountString,
                                      currency: currency,
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
