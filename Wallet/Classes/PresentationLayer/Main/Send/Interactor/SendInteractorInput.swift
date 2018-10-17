//
//  SendInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol SendInteractorInput: class {
    
    func getAccounts() -> [Account]
    func getAccountsCount() -> Int
    func getAccountIndex() -> Int
    func getConvertedAmount() -> Decimal
    func getAmount() -> Decimal?
    func getSelectedAccountCurrency() -> Currency
    func getReceiverCurrency() -> Currency
    
    func isValidAmount(_ amount: String) -> Bool
    func setAmount(_ amount: String)
    func setReceiverCurrency(_ currency: Currency)
    func setCurrentAccountWith(index: Int)
    func isFormValid() -> Bool
    
    func updateTransactionProvider()
    func getTransactionBuilder() -> SendProviderBuilderProtocol

}
