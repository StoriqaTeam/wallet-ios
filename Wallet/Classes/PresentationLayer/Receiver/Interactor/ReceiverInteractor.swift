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
    
    private let contactsProvider: ContactsProviderProtocol
    private var contactsDataManager: ContactsDataManager!
    
    init(contactsProvider: ContactsProviderProtocol) {
        self.contactsProvider = contactsProvider
    }
    
}


// MARK: - ReceiverInteractorInput

extension ReceiverInteractor: ReceiverInteractorInput {
    
    func createContactsDataManager(with tableView: UITableView) {
        
        //TODO: placeholder view
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = UIColor.cyan
        contactsDataManager = ContactsDataManager(placeHolderView: view)
        contactsDataManager.setTableView(tableView)
        
        contactsProvider.fetchContacts { [weak self] (result) in
            switch result {
            case .success(let sections):
                DispatchQueue.main.async {
                    self?.contactsDataManager.updateContacts(sections)
                }
            case .failure(let error):
                //TODO: placeholder view
                let view = UIView()
                view.backgroundColor = UIColor.red
                
                DispatchQueue.main.async {
                    self?.contactsDataManager.updateEmpty(view)
                }
                log.warn(error.localizedDescription)
            }
        }
        
    }
    
    func setContactsDataManagerDelegate(_ delegate: ContactsDataManagerDelegate) {
        contactsDataManager.delegate = delegate
    }
    
    func searchContact(text: String) {
        let filteredContacts = contactsProvider.searchContact(text: text)
        contactsDataManager.updateContacts(filteredContacts)
    }

}
