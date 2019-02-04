//
//  ExchangeInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ExchangeInteractorOutput: class {
    func updateFromAccounts(_ accounts: [Account], index: Int)
    func updateToAccounts(_ accounts: [Account], index: Int)
    func updateFromAmount(_ amount: Decimal, currency: Currency)
    func updateToAmount(_ amount: Decimal, currency: Currency)
    func updateIsEnoughFunds(_ enough: Bool)
    func updateFormIsValid(_ valid: Bool)
    func exchangeTxAmountOutOfLimit(min: String, max: String, currency: Currency)
    func exchangeTxFailed(message: String)
    func exchangeTxSucceed()
    func updateEmptyRate()
    func updateRateFor(oneUnit: Decimal, fromCurrency: Currency, toCurrency: Currency)
    func updateOrder(time: Int?)
    func exceededDayLimit(limit: String, currency: Currency)
    func exchangeRateError(_ error: Error)
}
