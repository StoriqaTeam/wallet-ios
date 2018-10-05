//
//  AccountDisplayableMapper.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 05/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class AccountDisplayableMapper: Mappable {
    typealias FromObj = Account
    typealias ToObj = AccountDisplayable
    
    private let currencyConverterFactory: CurrecncyConverterFactoryProtocol
    private let userDataStoreService: UserDataStoreServiceProtocol
    
    init(currencyConverterFactory: CurrecncyConverterFactoryProtocol, userDataStore: UserDataStoreServiceProtocol) {
        self.currencyConverterFactory = currencyConverterFactory
        self.userDataStoreService = userDataStore
    }
    
    func map(from obj: Account) -> AccountDisplayable {
        let balanceInCurrency = obj.balance.string
        let balance = obj.balance
        let currency = obj.currency
        let accountType = mapCurrency(currency, balance: balance)
        let userId = obj.userId
        let accountOwner = userDataStoreService.getUserWith(id: userId)
        let holderName = "\(accountOwner!.firstName) \(accountOwner!.lastName)"
        let converter = currencyConverterFactory.createConverter(from: currency)
        let fiatAmount = converter.convert(amount: balance, to: .fiat)
        let address = obj.accountAddress
        
        return  AccountDisplayable(type: accountType,
                                   cryptoAmount: balanceInCurrency,
                                   fiatAmount: fiatAmount.string,
                                   holderName: holderName,
                                   currency: currency,
                                   cryptoAddress: address)
        
    }
    
    
}


// MARK: - Private methods

extension AccountDisplayableMapper {
    
    // FIXME: - Needs ranges for gold and black STQ accounts from Nikita
    private func mapCurrency(_ currency: Currency, balance: Decimal) -> AccountType {
        switch currency {
            
        case .btc:
            return AccountType.btc
        case .eth:
            return AccountType.eth
        case .stq:
            if balance <= 1000 { return AccountType.stq }
            if balance > 1000 && balance <= 5000 { return AccountType.stqBlack }
            return AccountType.stqGold
        case .fiat:
            return .eth
        }
    }
}
