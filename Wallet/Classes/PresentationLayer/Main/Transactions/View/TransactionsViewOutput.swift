//
//  TransactionsViewOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionsViewOutput: class {
    func viewIsReady()
    func transactionTableView(_ tableView: UITableView)
    func willMoveToParentVC()
}
