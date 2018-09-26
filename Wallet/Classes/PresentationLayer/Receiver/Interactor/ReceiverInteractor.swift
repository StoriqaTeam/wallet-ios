//
//  ReceiverInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ReceiverInteractor {
    weak var output: ReceiverInteractorOutput!
    
    private var contactsDataManager: ContactsDataManager!
    private let deviceContactsProvider: DeviceContactsProviderProtocol
    private let sendProvider: SendTransactionBuilderProtocol
    
    init(deviceContactsProvider: DeviceContactsProviderProtocol,
         sendProvider: SendTransactionBuilderProtocol) {
        self.deviceContactsProvider = deviceContactsProvider
        self.sendProvider = sendProvider
    }
    
}


// MARK: - ReceiverInteractorInput

extension ReceiverInteractor: ReceiverInteractorInput {
    
    func getHeaderApperance() -> SendingHeaderData {
        
        let header = SendingHeaderData(amount: sendProvider.getAmountStr(),
                                       amountInTransactionCurrency: sendProvider.getAmountInTransactionCurrencyStr(),
                                       currencyImage: sendProvider.receiverCurrency.image)
        
        return header
    }
    
    func setScannedDelegate(_ delegate: QRScannerDelegate) {
        sendProvider.scanDelegate = delegate
    }
    
    func setContact(_ contact: Contact) {
        sendProvider.setContact(contact)
    }
    
    func getSendTransactionBuilder() -> SendTransactionBuilderProtocol {
        return sendProvider
    }
    
    func createContactsDataManager(with tableView: UITableView) {
        contactsDataManager = ContactsDataManager()
        contactsDataManager.setTableView(tableView)
        
        deviceContactsProvider.fetchContacts { [weak self] (result) in
            switch result {
            case .success(let sections):
                DispatchQueue.main.async {
                    self?.contactsDataManager.updateContacts(sections)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    //TODO: text and image in case of no access to contacts
                    self?.contactsDataManager.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"), placeholderText: error.localizedDescription)
                }
                log.warn(error.localizedDescription)
            }
        }
        
    }
    
    func setContactsDataManagerDelegate(_ delegate: ContactsDataManagerDelegate) {
        contactsDataManager.delegate = delegate
    }
    
    func searchContact(text: String) {
        let filteredContacts = deviceContactsProvider.searchContact(text: text)
        
        if filteredContacts.isEmpty {
            contactsDataManager.updateEmpty(placeholderImage: #imageLiteral(resourceName: "empty_phone_search"), placeholderText: "There is no such number in system.\nUse another way to send funds.")
        } else {
            contactsDataManager.updateContacts(filteredContacts)
        }
    }

}
