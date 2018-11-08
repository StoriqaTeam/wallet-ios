//
//  AccountsRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class AccountsRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - AccountsRouterInput

extension AccountsRouter: AccountsRouterInput {
    func showTransactions(from viewControoler: UIViewController, account: Account) {
        let moduleInput = TransactionsModule.create(app: app, account: account)
        moduleInput.present(from: viewControoler)
    }
    
    func showTransactionDetails(with transaction: TransactionDisplayable, from viewController: UIViewController) {
        TransactionDetailsModule.create(app: app, transaction: transaction).present(from: viewController)
    }
}
