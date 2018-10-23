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
    private let accountWatcher: CurrentAccountWatcherProtocol
    
    init(qrProvider: QRCodeProviderProtocol,
         accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol) {
        
        self.qrProvider = qrProvider
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
    }
}


// MARK: - DepositInteractorInput

extension DepositInteractor: DepositInteractorInput {
    func startObservers() {
        accountsProvider.setObserver(self)
    }
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getAccountIndex() -> Int {
        let account = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: account)
        return index
    }
    
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
    
    func getAccountsCount() -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.count
    }
}


// MARK: - AccountsProviderDelegate

extension DepositInteractor: AccountsProviderDelegate {
    func accountsDidUpdate(_ accounts: [Account]) {
        let account = accountWatcher.getAccount()
        let index = accounts.index { $0 == account } ?? 0
        
        accountWatcher.setAccount(accounts[index])
        output.updateAccounts(accounts: accounts, index: index)
    }
}


// MARK: - Private methods

extension DepositInteractor {
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account } ?? 0
    }
}
