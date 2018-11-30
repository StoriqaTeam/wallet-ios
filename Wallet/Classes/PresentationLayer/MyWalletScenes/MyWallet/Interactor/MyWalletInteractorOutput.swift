//
//  MyWalletInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol MyWalletInteractorOutput: class {
    func updateAccounts(accounts: [Account])
    func userDidUpdate()
    func receivedNewTxs(stq: Decimal, eth: Decimal, btc: Decimal)
}
