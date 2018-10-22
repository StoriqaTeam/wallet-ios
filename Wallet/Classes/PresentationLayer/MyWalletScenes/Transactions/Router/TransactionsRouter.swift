//
//  TransactionsRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionsRouter {
    
}


// MARK: - TransactionsRouterInput

extension TransactionsRouter: TransactionsRouterInput {
    func showTransactionDetails(with transaction: TransactionDisplayable, from viewController: UIViewController) {
        TransactionDetailsModule.create(transaction: transaction).present(from: viewController)
    }
    
    func showTransactionFilter(with transactionDateFilter: TransactionDateFilterProtocol, from viewController: UIViewController) {
        TransactionFilterModule.create(transactionDateFilter: transactionDateFilter).present(from: viewController)
    }
}
