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
    func getFee() -> Decimal?
    func getCurrency() -> Currency
    func getAddress() -> String
    
    func setAmount(_ amount: Decimal)
    func setCurrentAccount(index: Int, receiverAddress: String)
    func setPaymentFee(index: Int)
    func setAddress(_ address: String)
    
    func getTransactionBuilder() -> SendProviderBuilderProtocol
    func updateState(receiverAddress: String)
    func startObservers()
    func setScannedDelegate(_ delegate: QRScannerDelegate)
    func validateErc20Approved() -> Bool
    
    func sendTransaction() 
    func clearBuilder()

}
