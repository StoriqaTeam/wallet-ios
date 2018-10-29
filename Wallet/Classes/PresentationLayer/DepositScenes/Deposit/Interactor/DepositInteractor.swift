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
    private var accountsUpadteChannelInput: AccountsUpadteChannel?
    
    init(qrProvider: QRCodeProviderProtocol,
         accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol) {
        
        self.qrProvider = qrProvider
        self.accountsProvider = accountsProvider
        self.accountWatcher = accountWatcher
    }
    
    deinit {
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
    }
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
}


// MARK: - DepositInteractorInput

extension DepositInteractor: DepositInteractorInput {
    
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
    
    // MARK: Channels
    
    func startObservers() {
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
    }
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpadteChannel) {
        self.accountsUpadteChannelInput = channel
    }
}

// MARK: - Private methods

extension DepositInteractor {
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account } ?? 0
    }
    
    private func accountsDidUpdate(_ accounts: [Account]) {
        let account = accountWatcher.getAccount()
        let index = accounts.index { $0 == account } ?? 0
        
        accountWatcher.setAccount(accounts[index])
        output.updateAccounts(accounts: accounts, index: index)
    }
}
