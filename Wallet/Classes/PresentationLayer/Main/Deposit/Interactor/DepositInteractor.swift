//
//  DepositInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class DepositInteractor {
    weak var output: DepositInteractorOutput!
    private let qrProvider: QRCodeProviderProtocol
    private let accountsProvider: AccountsProviderProtocol
    private var accountsDataManager: AccountsDataManager!
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let accountDisplayer: AccountDisplayerProtocol
    
    init(qrProvider: QRCodeProviderProtocol,
         accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         accountDisplayer: AccountDisplayerProtocol) {
        
        self.qrProvider = qrProvider
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - DepositInteractorInput

extension DepositInteractor: DepositInteractorInput {
    func getAddress() -> String {
        let currentAccount = accountWatcher.getAccount()
        return currentAccount.accountAddress
    }
    
    func getQrCodeImage() -> UIImage {
        let currentAddress = accountWatcher.getAccount().accountAddress
        let qrCodeSize = CGSize(width: 300, height: 300)
        
        guard let qrCode = qrProvider.createQRFromString(currentAddress, size: qrCodeSize) else {
            return UIImage()
        }
        
        return qrCode
    }
    
    func setCurrentAccountWith(index: Int) {
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
    }
    
    func createAccountsDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountsProvider.getAllAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView, cellType: .small)
        accountsDataManager = accountsManager
    }
    
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate) {
        accountsDataManager.delegate = delegate
    }
    
    func scrollCollection() {
        let currentAccount = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: currentAccount)
        accountsDataManager.scrollTo(index: index)
    }
    
    func getAccountsCount() -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.count
    }
}


// MARK: - Private methods

extension DepositInteractor {
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account }!
    }
}
