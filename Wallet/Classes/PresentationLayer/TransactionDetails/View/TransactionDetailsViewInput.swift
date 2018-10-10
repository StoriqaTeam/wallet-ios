//
//  TransactionDetailsViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionDetailsViewInput: class, Presentable {
    func setupInitialState(transaction: TransactionDisplayable)
}
