//
//  AccountDisplayer.swift
//  Wallet
//
//  Created by Tata Gri on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountDisplayerProtocol {
    func cryptoAmount(for account: Account) -> String
    func fiatAmount(for account: Account) -> String
    func holderName() -> String
    func smallImage(for account: Account) -> UIImage
    func image(for account: Account) -> UIImage
    func textColor(for account: Account) -> UIColor
}

class AccountDisplayer: AccountDisplayerProtocol {
    
    private let user: User
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let accountTypeResolver: AccountTypeResolverProtocol
    
    init(user: User,
         currencyFormatter: CurrencyFormatterProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol,
         accountTypeResolver: AccountTypeResolverProtocol) {
        self.user = user
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        self.accountTypeResolver = accountTypeResolver
    }
    
    func cryptoAmount(for account: Account) -> String {
        let balance = account.balance
        let currency = account.currency
        let formatted = currencyFormatter.getStringFrom(amount: balance, currency: currency)
        return formatted
    }
    
    func fiatAmount(for account: Account) -> String {
        let balance = account.balance
        let currency = account.currency
        let converter = converterFactory.createConverter(from: currency)
        let fiat = converter.convert(amount: balance, to: currency)
        let formatted = currencyFormatter.getStringFrom(amount: fiat, currency: .fiat)
        return formatted
    }
    
    func holderName() -> String {
        let holderName = "\(user.firstName) \(user.lastName)"
        return holderName
    }
    
    func smallImage(for account: Account) -> UIImage {
        let accountType = accountTypeResolver.getType(for: account)
        
        switch accountType {
        case .btc:
            return UIImage(named: "smallBtcCard")!
        case .eth:
            return UIImage(named: "smallEthCard")!
        case .stq:
            return UIImage(named: "smallStqCard")!
        case .stqBlack:
            return UIImage(named: "smallStqBlackCard")!
        case .stqGold:
            return UIImage(named: "smallStqGoldCard")!
        }
    }
    
    func image(for account: Account) -> UIImage {
        let accountType = accountTypeResolver.getType(for: account)
        
        switch accountType {
        case .btc:
            return UIImage(named: "btcCard")!
        case .eth:
            return UIImage(named: "ethCard")!
        case .stq:
            return UIImage(named: "stqCard")!
        case .stqGold:
            return UIImage(named: "stqGoldCard")!
        case .stqBlack:
            return UIImage(named: "stqBlackCard")!
        }
    }
    
    func textColor(for account: Account) -> UIColor {
        let accountType = accountTypeResolver.getType(for: account)
        
        switch accountType {
        case .stqGold, .stqBlack:
            return UIColor.white
        default:
            return UIColor.black
        }
    }
    
}
