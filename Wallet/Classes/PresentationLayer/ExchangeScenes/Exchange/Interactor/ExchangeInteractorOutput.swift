//
//  ExchangeInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ExchangeInteractorOutput: class {
    func updateAccounts(accounts: [Account], index: Int)
    func updateRecepientAccount(_ account: Account?)
    func updateAmount(_ amount: Decimal, currency: Currency)
    func updateTotal(_ total: Decimal, currency: Currency)
    func updateIsEnoughFunds(_ enough: Bool)
    func updateFormIsValid(_ valid: Bool)
    func exchangeTxFailed(message: String)
    func exchangeTxSucceed()
}
