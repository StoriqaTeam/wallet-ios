//
//  TransactionsRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionsRouterInput: class {
    func showTransactionDetails(with transaction: Transaction, from viewController: UIViewController)
}
