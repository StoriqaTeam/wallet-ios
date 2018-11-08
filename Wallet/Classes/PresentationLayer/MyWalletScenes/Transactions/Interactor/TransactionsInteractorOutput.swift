//
//  TransactionsInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol TransactionsInteractorOutput: class {
    func updateTransactions(_ txs: [Transaction])
}
