//
//  TransactionsRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionsRouter {
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - TransactionsRouterInput

extension TransactionsRouter: TransactionsRouterInput {
    func showTransactionDetails(with transaction: TransactionDisplayable, from viewController: UIViewController) {
        TransactionDetailsModule.create(app: app, transaction: transaction).present(from: viewController)
    }
    
    func showTransactionFilter(with transactionDateFilter: TransactionDateFilterProtocol, from viewController: UIViewController) {
        TransactionFilterModule.create(app: app, transactionDateFilter: transactionDateFilter).present(from: viewController)
    }
}
