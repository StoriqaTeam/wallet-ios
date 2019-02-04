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
    func getRecipientAccounts() -> [Account]
    func getAccountIndex() -> Int
    func getFromAmount() -> Decimal
    func getToAmount() -> Decimal
    func getFromCurrency() -> Currency
    func getToCurrency() -> Currency
    func getFromAccountName() -> String
    func getToAccountName() -> String
    
    func setFromAccount(index: Int)
    func setToAccount(index: Int)
    func setFromAmount(_ amount: Decimal)
    func setToAmount(_ amount: Decimal)
    
    func getTransactionBuilder() -> ExchangeProviderBuilderProtocol
    func updateState()
    func startObservers()
    
    func sendTransaction()
    func clearBuilder()
}
