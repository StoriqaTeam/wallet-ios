//
//  AccountsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsProviderProtocol: class {
    func getAllAccounts() -> [Account]
}


class AccountsProvider: AccountsProviderProtocol {
    func getAllAccounts() -> [Account] {
        fatalError("Need to implement")
    }
}
