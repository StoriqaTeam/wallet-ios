//
//  AccountsInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol AccountsInteractorInput: class {
    func getCurrentAccount() -> Account
    func getInitialCurrencyISO() -> String
    func createAccountsDataManager(with collectionView: UICollectionView)
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate)
    func createTransactionsDataManager(with tableView: UITableView)
    func setTransactionDataManagerDelegate(_ delegate: LastTransactionsDataManagerDelegate)
    func setCurrentAccountWith(index: Int)
    func scrolCollection()
}
