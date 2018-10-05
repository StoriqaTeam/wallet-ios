//
//  AccountsProvider.swift
//  Wallet
//
//  Created by Daniil Miroshnichecko on 21.09.2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

protocol AccountsProviderProtocol: class {
    func getAllAccounts() -> [AccountDisplayable]
}


class AccountsProvider: AccountsProviderProtocol {
    func getAllAccounts() -> [AccountDisplayable] {
        fatalError("Need to implement")
    }
}
