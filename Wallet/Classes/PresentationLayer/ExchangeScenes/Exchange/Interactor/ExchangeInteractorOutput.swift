//
//  ExchangeInteractorOutput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ExchangeInteractorOutput: class {
    
    func updateRecepientAccount(_ account: Account?)
    func updateAmount(_ amount: Decimal, currency: Currency)
    func convertAmount(_ amount: Decimal, to currency: Currency)
    func updatePaymentFee(_ fee: Decimal?)
    func updatePaymentFees(count: Int, selected: Int)
    func updateMedianWait(_ wait: String)
    func updateTotal(_ total: Decimal, accountCurrency: Currency)
    func updateIsEnoughFunds(_ enough: Bool)
    func updateFormIsValid(_ valid: Bool)
    func updateAccounts(accounts: [Account], index: Int)
    
}
