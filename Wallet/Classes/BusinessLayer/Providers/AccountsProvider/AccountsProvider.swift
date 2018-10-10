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
    func getEthereumAddress() -> String
    func getBitcoinAddress() -> String
}


class AccountsProvider: AccountsProviderProtocol {
    func getEthereumAddress() -> String {
        fatalError("Need to implement")
    }
    
    func getBitcoinAddress() -> String {
        fatalError("Need to implement")
    }
    
    
    func getAllAccounts() -> [Account] {
        fatalError("Need to implement")
    }
}
