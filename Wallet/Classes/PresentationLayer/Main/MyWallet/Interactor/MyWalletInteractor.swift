//
//  MyWalletInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class MyWalletInteractor {
    weak var output: MyWalletInteractorOutput!
    
    private let accountsProvider: AccountsProviderProtocol
    
    init(accountsProvider: AccountsProviderProtocol) {
        self.accountsProvider = accountsProvider
    }
}


// MARK: - MyWalletInteractorInput

extension MyWalletInteractor: MyWalletInteractorInput {
    
    func accountsCount() -> Int {
        let accounts = accountsProvider.getAllAccounts()
        return accounts.count
    }
    
    func accountModel(for index: Int) -> Account {
        let accounts = accountsProvider.getAllAccounts()
        guard accounts.count > index else { fatalError("Not found account at given index: \(index)") }
        return accounts[index]
    }
    
}
