//
//  ExchangeInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ExchangeInteractor {
    weak var output: ExchangeInteractorOutput!
    private let accountsLinker: AccountsLinkerProtocol
    private var accountsDataManager: AccountsDataManager!
    private var walletsDataManager: WalletsDataManager!
    private let accountWatcher: CurrentAccountWatcherProtocol
    
    init(accountsLinker: AccountsLinkerProtocol, accountWatcher: CurrentAccountWatcherProtocol) {
        self.accountsLinker = accountsLinker
        self.accountWatcher = accountWatcher

    }
}


// MARK: - ExchangeInteractorInput

extension ExchangeInteractor: ExchangeInteractorInput {
    func getAccountsCount() -> Int {
        let allAccounts = accountsLinker.getAllAccounts()
        return allAccounts.count
    }
    
    func createWalletsDataManager(with tableView: UITableView) {
        let walletsManager = WalletsDataManager()
        walletsManager.setTableView(tableView)
        walletsDataManager = walletsManager
    }
    
    func scrollCollection() {
        let currentAccount = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: currentAccount)
        accountsDataManager.scrollTo(index: index)
    }
    
    func setWalletsDataManagerDelegate(_ delegate: WalletsDataManagerDelegate) {
        walletsDataManager.delegate = delegate
    }
    
    func createAccountsDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountsLinker.getAllAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts)
        accountsManager.setCollectionView(collectionView)
        accountsDataManager = accountsManager
    }
    
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate) {
         accountsDataManager.delegate = delegate
    }
}


// MARK: - Private methods

extension ExchangeInteractor {
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsLinker.getAllAccounts()
        return allAccounts.index{$0 == account}!
    }
}
