//
//  ExchangeInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ExchangeInteractorInput: class {
    func getAccounts() -> [Account]
    func getRecepientAccounts() -> [Account]
    func getAccountIndex() -> Int
    func getAccountsCount() -> Int
    func getAmount() -> Decimal
    func getAccountCurrency() -> Currency
    func getRecepientCurrency() -> Currency
    
    func setCurrentAccount(index: Int)
    func setAmount(_ amount: Decimal)
    
    func getTransactionBuilder() -> ExchangeProviderBuilderProtocol
    func updateState()
    func startObservers()
    
    func sendTransaction()
    func clearBuilder()
}
