//
//  ExchangeInteractorInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


protocol ExchangeInteractorInput: class {
    
    func createAccountsDataManager(with collectionView: UICollectionView)
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate)
    func scrollCollection()
    
    func createAccountsTableDataManager(with tableView: UITableView)
    func setAccountsTableDataManagerDelegate(_ delegate: AccountsTableDataManagerDelegate)
    func prepareAccountsTable()
    func getAccountsTableHeight() -> CGFloat
    
    func getAccountsCount() -> Int
    
    func getAmount() -> Decimal
    func getAccountCurrency() -> Currency
    func getRecepientCurrency() -> Currency
    
    func setCurrentAccount(index: Int)
    func setRecepientAccount(index: Int)
    func setAmount(_ amount: Decimal)
    func setPaymentFee(index: Int)
    
    func updateInitialState()
    
}
