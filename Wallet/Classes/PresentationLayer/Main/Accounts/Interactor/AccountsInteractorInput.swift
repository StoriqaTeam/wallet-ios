//
//  AccountsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AccountsInteractorInput: class {
    
    func getAccounts() -> [Account]
    func getAccountIndex() -> Int
    func getInitialCurrencyISO() -> String
    func getTransactionForCurrentAccount() -> [Transaction]
    func getAccountsCount() -> Int
    func setCurrentAccountWith(index: Int)
    
}
