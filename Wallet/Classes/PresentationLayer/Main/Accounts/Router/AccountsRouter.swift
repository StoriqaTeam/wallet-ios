//
//  AccountsRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class AccountsRouter {

}


// MARK: - AccountsRouterInput

extension AccountsRouter: AccountsRouterInput {
    func showTransactions(from viewControoler: UIViewController, transactions: [Transaction]) {
        let moduleInput = TransactionsModule.create(transactions: transactions)
        moduleInput.present(from: viewControoler)
    }
    
    func showDeposit(with account: Account) {
        DepositModule.create(account: account).present()
    }
    
    func showChange(with account: Account) {
        ExchangeModule.create(account: account).present()
    }
    
    func showSend(with account: Account) {
//        SendModule.create(account: account).present()
    }
}
