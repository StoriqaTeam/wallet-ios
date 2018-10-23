//
//  ReceiverInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ReceiverInteractorInput: class {
    
    func loadContacts()
    func getSendTransactionBuilder() -> SendProviderBuilderProtocol 
    func setScannedDelegate(_ delegate: QRScannerDelegate)
    func setContact(_ contact: ContactDisplayable)
    func getContact() -> ContactDisplayable?

    func getAmount() -> Decimal?
    func getReceiverCurrency() -> Currency
    func getSelectedAccount() -> Account
    
}
