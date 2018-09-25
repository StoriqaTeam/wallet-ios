//
//  AccountsRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol AccountsRouterInput: class {
    func showDeposit(with account: Account)
    func showChange(with account: Account)
    func showSend(with account: Account)
}
