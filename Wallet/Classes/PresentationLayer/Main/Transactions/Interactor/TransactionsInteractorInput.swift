//
//  TransactionsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionsInteractorInput: class {
    func getTransactions() -> [TransactionDisplayable]
    func getFilteredTransacitons(index: Int) -> [TransactionDisplayable]
    func getTransactionDateFilter() -> TransactionDateFilterProtocol
}
