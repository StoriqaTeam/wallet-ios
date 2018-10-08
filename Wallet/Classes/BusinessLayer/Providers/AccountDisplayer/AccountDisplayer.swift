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
    func holderName(for account: Account) -> String
    func smallImage(for account: Account) -> UIImage
    func image(for account: Account) -> UIImage
    func textColor(for account: Account) -> UIColor
}

class AccountDisplayer: AccountDisplayerProtocol {
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol,
         userDataStoreService: UserDataStoreServiceProtocol) {
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        self.userDataStoreService = userDataStoreService
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
    
    func holderName(for account: Account) -> String {
        let accountOwner = userDataStoreService.getUserWith(id: account.userId)!
        let holderName = "\(accountOwner.firstName) \(accountOwner.lastName)"
        return holderName
    }
    
    func smallImage(for account: Account) -> UIImage {
        switch account.currency {
        case .btc:
            return UIImage(named: "smallBtcCard")!
        case .eth:
            return UIImage(named: "smallEthCard")!
        case .stq:
            let balance = account.balance
            
            if isStqGold(with: balance) {
                return UIImage(named: "smallStqGoldCard")!
            } else if isStqBlack(with: balance) {
                return UIImage(named: "smallStqBlackCard")!
            } else {
                return UIImage(named: "smallStqCard")!
            }
        default:
            return UIImage()
        }
    }
    
    func image(for account: Account) -> UIImage {
        switch account.currency {
        case .btc:
            return UIImage(named: "btcCard")!
        case .eth:
            return UIImage(named: "ethCard")!
        case .stq:
            let balance = account.balance
            
            if isStqGold(with: balance) {
                return UIImage(named: "stqGoldCard")!
            } else if isStqBlack(with: balance) {
                return UIImage(named: "stqBlackCard")!
            } else {
                return UIImage(named: "stqCard")!
            }
        default:
            return UIImage()
        }
    }
    
    func textColor(for account: Account) -> UIColor {
        let balance = account.balance
        
        if account.currency == .stq &&
            (isStqBlack(with: balance) || isStqGold(with: balance)) {
            return UIColor.white
        } else {
            return UIColor.black
        }
    }
    
}

// MARK: - Private methods

extension AccountDisplayer {
    
    private func isStqGold(with balance: Decimal) -> Bool {
        return balance > 5000
    }
    
    private func isStqBlack(with balance: Decimal) -> Bool {
        return balance > 1000 && balance <= 5000
    }
    
}
