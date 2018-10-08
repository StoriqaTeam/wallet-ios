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
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let accountDisplayer: AccountDisplayerProtocol
    private var dataManager: MyWalletDataManager!
    
    init(accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         accountDisplayer: AccountDisplayerProtocol) {
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - MyWalletInteractorInput

extension MyWalletInteractor: MyWalletInteractorInput {
    
    func getAccountWatcher() -> CurrentAccountWatcherProtocol {
        return accountWatcher
    }
    
    func createDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountsProvider.getAllAccounts()
        let accountsManager = MyWalletDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView)
        dataManager = accountsManager
    }
    
    func setDataManagerDelegate(_ delegate: MyWalletDataManagerDelegate) {
        dataManager.delegate = delegate
    }
    
}
