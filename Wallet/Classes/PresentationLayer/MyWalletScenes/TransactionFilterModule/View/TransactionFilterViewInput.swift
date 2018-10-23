//
//  TransactionFilterModuleViewInput.swift
//  wallet-ios
//
//  Created by Storiqa on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol TransactionFilterViewInput: class, Presentable {
    func setupInitialState()
    func buttonsChangedState(isEnabled: Bool)
    func fillTextFileld(fromDate: Date, toDate: Date)
}
