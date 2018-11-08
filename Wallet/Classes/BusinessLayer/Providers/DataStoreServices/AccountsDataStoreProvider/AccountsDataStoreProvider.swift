//
//  AccountsDataStoreProvider.swift
//  Wallet
//
//  Created by Storiqa on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AccountsDataStoreServiceProtocol: class {
    func update(_ accounts: [Account])
    func save(_ account: Account)
    func getAllAccounts() -> [Account]
    func observe(updateHandler: @escaping ([Account]) -> Void)
}


class AccountsDataStoreService: RealmStorable<Account>, AccountsDataStoreServiceProtocol {
    
    private var updateHandler: (([Account]) -> Void)?
    
    func update(_ accounts: [Account]) {
        notificationToken?.invalidate()
        notificationToken = nil
        
        find().forEach { delete(primaryKey: $0.id) }
        save(accounts)
        
        if let updateHandler = updateHandler {
            super.observe(updateHandler: updateHandler)
        }
    }
    
    func getAllAccounts() -> [Account] {
        return find()
    }
    
    
    override func observe(updateHandler: @escaping ([Account]) -> Void) {
        self.updateHandler = updateHandler
        super.observe(updateHandler: updateHandler)
    }
}
