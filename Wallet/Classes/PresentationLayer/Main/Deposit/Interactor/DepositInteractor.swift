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
    private var account: Account?
    
    init(qrProvider: QRCodeProviderProtocol, accountsProvider: AccountsProviderProtocol, account: Account?) {
        self.qrProvider = qrProvider
        self.accountsProvider = accountsProvider
        if let acc = account {
            self.account = acc
            return
        }
        
        setInitialAccount()
    }
}


// MARK: - DepositInteractorInput

extension DepositInteractor: DepositInteractorInput {
    func getAddress() -> String {
        guard let account = account else {
            return ""
        }
        
        return account.cryptoAddress
    }
    
    func getQrCodeImage() -> UIImage {
        guard let addr = account?.cryptoAddress,
            let qrCode = qrProvider.createQRFromString(addr, size: CGSize(width: 300, height: 300)) else {
            return UIImage()
        }
        
        return qrCode
    }
    
    func setCurrentAccountWith(index: Int) {
        let allAccounts = accountsProvider.getAllAccounts()
        account = allAccounts[index]
    }
    
    func createAccountsDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountsProvider.getAllAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts)
        accountsManager.setCollectionView(collectionView, cellType: .small)
        accountsDataManager = accountsManager
    }
    
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate) {
        accountsDataManager.delegate = delegate
    }
    
    func scrollCollection() {
        guard let account = account else {
            return
        }
        let index = resolveAccountIndex(account: account)
        accountsDataManager.scrollTo(index: index)
    }
    
    func getAccountsCount() -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.count
    }
}


// MARK: - Private methods

extension DepositInteractor {
    private func setInitialAccount() {
        let allAccount = accountsProvider.getAllAccounts()
        if allAccount.count == 0 {
            account = nil
            return
        }
        
        account = allAccount[0]
    }
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index{$0 == account}!
    }
}
