//
//  AccountsDataStoreProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 24.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AccountsDataStoreServiceProtocol: class {
    func update(_ accounts: [Account])
    func getAllAccounts(userId: Int) -> [Account]
    func observe(updateHandler: @escaping ([Account]) -> Void)
}


class AccountsDataStoreService: RealmStorable<Account>, AccountsDataStoreServiceProtocol {
    
    func update(_ accounts: [Account]) {
        find().forEach { delete(primaryKey: $0.id) }
        save(accounts)
    }
    
    func getAllAccounts(userId: Int) -> [Account] {
        let allAccounts = find()
        let usersAccounts = allAccounts.filter {
            return $0.userId == userId
        }
        return usersAccounts
    }
}
