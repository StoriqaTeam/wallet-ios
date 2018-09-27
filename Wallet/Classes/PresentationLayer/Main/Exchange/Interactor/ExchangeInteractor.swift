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
    private var account: Account?
    
    init(accountsLinker: AccountsLinkerProtocol, account: Account?) {
        self.accountsLinker = accountsLinker
        if let acc = account {
            self.account = acc
            return
        }
        
        setInitialAccount()
    }
}


// MARK: - ExchangeInteractorInput

extension ExchangeInteractor: ExchangeInteractorInput {
    func createWalletsDataManager(with tableView: UITableView) {
        let walletsManager = WalletsDataManager()
        walletsManager.setTableView(tableView)
        walletsDataManager = walletsManager
    }
    
    func scrollCollection() {
        guard let account = account else {
            return
        }
        let index = resolveAccountIndex(account: account)
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
    private func setInitialAccount() {
        let allAccount = accountsLinker.getAllAccounts()
        if allAccount.count == 0 {
            account = nil
            return
        }
        
        account = allAccount[0]
    }
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsLinker.getAllAccounts()
        return allAccounts.index{$0 == account}!
    }
}
