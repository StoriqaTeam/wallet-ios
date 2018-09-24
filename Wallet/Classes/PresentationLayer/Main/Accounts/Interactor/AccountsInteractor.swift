//
//  AccountsInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation

class AccountsInteractor {
    
    weak var output: AccountsInteractorOutput!
    private let account: Account
    private var accountsDataManager: AccountsDataManager!
    private var transactionDataManager: LastTransactionsDataManager!
    private let accountLinker: AccountsLinkerProtocol
    
    init(accountLinker: AccountsLinkerProtocol,
         account: Account) {
        
        self.accountLinker = accountLinker
        self.account = account
    }
}


// MARK: - AccountsInteractorInput

extension AccountsInteractor: AccountsInteractorInput {
    
    func getInitialCurrencyISO() -> String {
        return account.type.ICO
    }
    
    func setTransactionDataManagerDelegate(_ delegate: LastTransactionsDataManagerDelegate) {
        transactionDataManager.delegate = delegate
    }
    
    
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate) {
        accountsDataManager.delegate = delegate
    }
    
    func createAccountsDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountLinker.getAllAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts)
        accountsManager.setCollectionView(collectionView)
        accountsDataManager = accountsManager
    }
    
    func createTransactionsDataManager(with tableView: UITableView) {
        guard let transactions = accountLinker.getTransactionsFor(account: account) else {
            fatalError("Given Account do not exist")
        }
        
        let txDataManager = LastTransactionsDataManager(transactions: transactions)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
    }
}
