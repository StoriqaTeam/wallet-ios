//
//  AccountsRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol AccountsRouterInput: class {
    func showTransactions(from viewControoler: UIViewController, account: Account)
    func showTransactionDetails(with transaction: TransactionDisplayable, from viewController: UIViewController)
}
