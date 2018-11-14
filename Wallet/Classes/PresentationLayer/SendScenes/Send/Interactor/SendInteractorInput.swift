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
    func getAmount() -> Decimal?
    func getFee() -> Decimal
    func getCurrency() -> Currency
    func getAddress() -> String
    
    func setAmount(_ amount: String)
    func setCurrentAccount(index: Int)
    func setPaymentFee(index: Int)
    func setAddress(_ address: String)
    
    func isValidAmount(_ amount: String) -> Bool
    
    func getTransactionBuilder() -> SendProviderBuilderProtocol
    func updateState()
    func startObservers()
    func setScannedDelegate(_ delegate: QRScannerDelegate)
    
    func sendTransaction() 
    func clearBuilder()

}
