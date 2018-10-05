//
//  ReceiverInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ReceiverInteractorInput: class {
    
    func createContactsDataManager(with tableView: UITableView)
    func setContactsDataManagerDelegate(_ delegate: ContactsDataManagerDelegate)
    func searchContact(text: String)
    func getSendTransactionBuilder() -> SendProviderBuilderProtocol 
    func setScannedDelegate(_ delegate: QRScannerDelegate)
    func setContact(_ contact: Contact)
    func getContact() -> [Contact]

    func getAmount() -> Decimal?
    func getReceiverCurrency() -> Currency
    func getSelectedAccount() -> AccountDisplayable
    
}
