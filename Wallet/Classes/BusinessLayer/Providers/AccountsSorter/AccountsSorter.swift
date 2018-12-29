//
//  AccountsSorter.swift
//  Wallet
//
//  Created by Storiqa on 28/12/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsSorterProtocol {
    func sortAccounts(_ accounts: [Account], visibleCurrency: Currency  ) -> [Account]
}


class AccountsSorter: AccountsSorterProtocol {
    
    func sortAccounts(_ accounts: [Account], visibleCurrency: Currency) -> [Account] {
        
        var sortedAccounts = accounts
        guard let lastAccountCurrency = accounts.last?.currency,
                  lastAccountCurrency != visibleCurrency else { return sortedAccounts }
        
        let index = accounts.index { $0.currency == visibleCurrency }
        guard let indexOfSTQAccount = index else { return sortedAccounts }
        let lastAccountIndex = sortedAccounts.count - 1
        sortedAccounts.swapAt(indexOfSTQAccount, lastAccountIndex)
        
        return sortedAccounts
    }
}
