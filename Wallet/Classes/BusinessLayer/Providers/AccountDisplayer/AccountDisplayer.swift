//
//  AccountDisplayer.swift
//  Wallet
//
//  Created by Storiqa on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountDisplayerProtocol {
    func cryptoAmount(for account: Account) -> String
    func cryptoAmountWithoutCurrency(for account: Account) -> String
    func fiatAmount(for account: Account) -> String
    func currency(for account: Account) -> String
    func accountName(for account: Account) -> String
    func smallImage(for account: Account) -> UIImage
    func thinImage(for account: Account) -> UIImage
    func image(for account: Account) -> UIImage
    func textColor(for account: Account) -> UIColor
}

class AccountDisplayer: AccountDisplayerProtocol {
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrencyConverterFactoryProtocol
    private let accountTypeResolver: AccountTypeResolverProtocol
    private let denominationUnitsConverter: DenominationUnitsConverterProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         converterFactory: CurrencyConverterFactoryProtocol,
         accountTypeResolver: AccountTypeResolverProtocol,
         denominationUnitsConverter: DenominationUnitsConverterProtocol) {
        
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        self.accountTypeResolver = accountTypeResolver
        self.denominationUnitsConverter = denominationUnitsConverter
    }
    
    func cryptoAmount(for account: Account) -> String {
        let currency = account.currency
        let balance = denominationUnitsConverter.amountToMaxUnits(account.balance, currency: currency)
        let formatted = currencyFormatter.getStringFrom(amount: balance, currency: currency)
        return formatted
    }
    
    func cryptoAmountWithoutCurrency(for account: Account) -> String {
        let currency = account.currency
        let balance = denominationUnitsConverter.amountToMaxUnits(account.balance, currency: currency)
        let formatted = currencyFormatter.getStringWithoutCurrencyFrom(amount: balance, currency: currency)
        return formatted
    }
    
    func fiatAmount(for account: Account) -> String {
        let currency = account.currency
        let balance = denominationUnitsConverter.amountToMaxUnits(account.balance, currency: currency)
        let converter = converterFactory.createConverter(from: currency)
        let defaultFiat = Currency.defaultFiat
        let fiat = converter.convert(amount: balance, to: defaultFiat)
        let formatted = currencyFormatter.getStringFrom(amount: fiat, currency: defaultFiat)
        return formatted
    }
    
    func currency(for account: Account) -> String {
        let currency = account.currency
        return currency.ISO
    }
    
    func accountName(for account: Account) -> String {
        return account.name
    }
    
    func smallImage(for account: Account) -> UIImage {
        let accountType = accountTypeResolver.getType(for: account)
        
        switch accountType {
        case .btc:
            return UIImage(named: "smallBtcCard")!
        case .eth:
            return UIImage(named: "smallEthCard")!
        case .stq, .stqGold, .stqBlack:
            return UIImage(named: "smallStqCard-red")!
        }
    }
    
    func thinImage(for account: Account) -> UIImage {
        let accountType = accountTypeResolver.getType(for: account)
        
        switch accountType {
        case .btc:
            return UIImage(named: "thinBtcCard")!
        case .eth:
            return UIImage(named: "thinEthCard")!
        case .stq, .stqGold, .stqBlack:
            return UIImage(named: "thinStqCard-red")!
        }
    }
    
    func image(for account: Account) -> UIImage {
        let accountType = accountTypeResolver.getType(for: account)
        
        switch accountType {
        case .btc:
            return UIImage(named: "btcCard")!
        case .eth:
            return UIImage(named: "ethCard")!
        case .stq, .stqGold, .stqBlack:
            return UIImage(named: "stqCard-red")!
        }
    }
    
    func textColor(for account: Account) -> UIColor {
        return UIColor.white
    }
}
