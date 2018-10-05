//
//  AccountsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AccountsInteractorInput: class {
    
    func scrollCollection()
    func getInitialCurrencyISO() -> String
    
    func setCurrentAccountWith(index: Int)
    func getCurrentAccount() -> AccountDisplayable
    func getTransactionForCurrentAccount() -> [Transaction]
    func getAccountsCount() -> Int
    
    func createAccountsDataManager(with collectionView: UICollectionView)
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate)
    func createTransactionsDataManager(with tableView: UITableView)
    func setTransactionDataManagerDelegate(_ delegate: TransactionsDataManagerDelegate)
    
}
