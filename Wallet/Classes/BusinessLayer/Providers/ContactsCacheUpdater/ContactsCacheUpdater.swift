//
//  ContactsCacheUpdater.swift
//  Wallet
//
//  Created by Tata Gri on 16/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol ContactsCacheUpdaterProtocol {
    func update(errorHandler: @escaping (Error) -> Void )
}

class ContactsCacheUpdater: ContactsCacheUpdaterProtocol {
    
    private let deviceContactsFetcher: DeviceContactsFetcherProtocol
    private let contactsNetworkProvider: ContactsNetworkProviderProtocol
    private let contactsAddressLinker: ContactsAddressLinkerProtocol
    
    private var contacts = [Contact]()
    
    init(deviceContactsFetcher: DeviceContactsFetcherProtocol,
         contactsNetworkProvider: ContactsNetworkProviderProtocol,
         contactsAddressLinker: ContactsAddressLinkerProtocol) {
        self.deviceContactsFetcher = deviceContactsFetcher
        self.contactsNetworkProvider = contactsNetworkProvider
        self.contactsAddressLinker = contactsAddressLinker
    }
    
    func update(errorHandler: @escaping (Error) -> Void ) {
        deviceContactsFetcher.fetchContacts { [weak self] (result) in
            switch result {
            case .success(let contacts):
                self?.contacts = contacts
                self?.loadAddresses(contacts: contacts)
            case .failure(let error):
                errorHandler(error)
                log.warn(error.localizedDescription)
            }
        }
    }
}


// MARK: Private methods

extension ContactsCacheUpdater {
    private func loadAddresses(contacts: [Contact]) {
        let ids = contacts.map { $0.id }
        
        contactsNetworkProvider.getContacts(ids: ids) { [weak self] (result) in
            switch result {
            case .success(let pairs):
                self?.contactsAddressLinker.link(contacts: contacts, address: pairs)
            case .failure:
                // TODO: handle error
                break
            }
        }
    }
}
