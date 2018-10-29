//
//  PaymentFeeInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol PaymentFeeInteractorInput: class {
     func sendTransaction(completion: @escaping (Result<Transaction>) -> Void) 
    
    func getSendTransactionBuilder() -> SendProviderBuilderProtocol
    func setPaymentFee(index: Int)
    func getFeeAndWait() -> (fee: String, wait: String)
    func getAddress() -> String
    func getSubtotal() -> Decimal
    func isEnoughFunds() -> Bool
    func createTransaction() -> Transaction?

    func getAmount() -> Decimal
    func getConvertedAmount() -> Decimal
    func getReceiverCurrency() -> Currency
    func getSelectedAccount() -> Account
    func getOpponent() -> OpponentType
    func getFeeWaitCount() -> Int
    
    func clearBuilder()
}
