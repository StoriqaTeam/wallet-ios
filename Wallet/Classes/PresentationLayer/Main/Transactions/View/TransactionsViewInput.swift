//
//  TransactionsViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionsViewInput: class, Presentable {
    func setupInitialState()
}
