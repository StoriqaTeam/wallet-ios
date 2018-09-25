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
}
