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
    func createWalletsDataManager(with tableView: UITableView)
    func setWalletsDataManagerDelegate(_ delegate: WalletsDataManagerDelegate)
    func scrollCollection()
    func getAccountsCount() -> Int
}
