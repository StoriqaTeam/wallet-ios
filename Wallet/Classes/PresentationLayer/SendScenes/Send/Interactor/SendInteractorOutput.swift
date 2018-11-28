//
//  SendInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SendInteractorOutput: class {
    func updateAccounts(accounts: [Account], index: Int)
    func updateAmount(_ amount: Decimal, currency: Currency)
    func updatePaymentFee(_ fee: Decimal?)
    func updatePaymentFees(count: Int, selected: Int)
    func updateMedianWait(_ wait: String)
    func updateTotal(_ total: Decimal, currency: Currency)
    func updateIsEnoughFunds(_ enough: Bool)
    func updateFormIsValid(_ valid: Bool)
    func updateAddressIsValid(_ valid: Bool)
    func setFeeUpdating(_ isUpdating: Bool)
    func setWrongCurrency(message: String)
    func sendTxFailed(message: String)
    func sendTxSucceed()
    func exceededDayLimit(limit: String, currency: Currency)
}
