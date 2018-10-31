//
//  AccountsLinker.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AccountsLinkerProtocol: class {
    func getTransactionsFor(account: Account) -> [Transaction]?
    func getAllAccounts() -> [Account]
}


class AccountsLinker: AccountsLinkerProtocol {
    
    private let accountsProvider: AccountsProviderProtocol
    private let transactionsProvider: TransactionsProviderProtocol

    init(accountsProvider: AccountsProviderProtocol, transactionsProvider: TransactionsProviderProtocol) {
        self.accountsProvider = accountsProvider
        self.transactionsProvider = transactionsProvider
    }
   
    // @dev returns nil if given account not found
    func getTransactionsFor(account: Account) -> [Transaction]? {
        let allAccounts = accountsProvider.getAllAccounts()
        
        for acc in allAccounts where acc == account {
            return transactionsProvider.transactionsFor(account: acc)
        }
        
        return nil
    }
    
    func getAllAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
}
