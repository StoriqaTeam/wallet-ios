//
//  AccountsInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AccountsInteractorOutput: class {
    func ISODidChange(_ iso: String)
    func transactionsDidChange(_ txs: [TransactionDisplayable])
}
