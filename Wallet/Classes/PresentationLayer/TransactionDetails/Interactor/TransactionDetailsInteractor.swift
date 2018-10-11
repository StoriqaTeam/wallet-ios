//
//  TransactionDetailsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class TransactionDetailsInteractor {
    weak var output: TransactionDetailsInteractorOutput!
    private let transaction: TransactionDisplayable
    
    init(transaction: TransactionDisplayable) {
        self.transaction = transaction
    }
}


// MARK: - TransactionDetailsInteractorInput

extension TransactionDetailsInteractor: TransactionDetailsInteractorInput {
    func getTransaction() -> TransactionDisplayable {
        return transaction
    }
}
