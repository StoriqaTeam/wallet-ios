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
    func showTransactions(from viewControoler: UIViewController, account: Account) {
        let moduleInput = TransactionsModule.create(account: account)
        moduleInput.present(from: viewControoler)
    }
    
    func showTransactionDetails(with transaction: TransactionDisplayable, from viewController: UIViewController) {
        TransactionDetailsModule.create(transaction: transaction).present(from: viewController)
    }
}
