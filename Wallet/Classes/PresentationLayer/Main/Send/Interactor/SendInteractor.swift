//
//  SendInteractor.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SendInteractor {
    weak var output: SendInteractorOutput!
    private var accountsDataManager: AccountsDataManager!
    private let accountsProvider: AccountsProviderProtocol
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let sendTransactionBuilder: SendProviderBuilderProtocol
    private let sendProvider: SendTransactionProvider
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol,
         accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol) {
        
        self.accountsProvider = accountsProvider
        self.sendTransactionBuilder = sendTransactionBuilder
        self.accountWatcher = accountWatcher
        self.sendProvider = sendTransactionBuilder.build()
        
        let account = accountWatcher.getAccount()
        setInitialAccount(account: account)
    }
}


// MARK: - SendInteractorInput

extension SendInteractor: SendInteractorInput {
    
    func getAccountsCount() -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.count
    }
    
    func getTransactionBuilder() -> SendProviderBuilderProtocol {
        return sendTransactionBuilder
    }
    
    func setCurrentAccountWith(index: Int) {
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        let account = allAccounts[index]
        sendTransactionBuilder.set(account: account)
        output.updateAmount(sendProvider.getAmountStr())
        output.updateConvertedAmount(sendProvider.getAmountInTransactionCurrencyStr())
    }
    
    func scrollCollection() {
        let currentAccount = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: currentAccount)
        accountsDataManager.scrollTo(index: index)
    }
    
    func setReceiverCurrency(_ currency: Currency) {
        sendTransactionBuilder.setReceiverCurrency(currency)
        output.updateAmount(sendProvider.getAmountStr())
        output.updateConvertedAmount(sendProvider.getAmountInTransactionCurrencyStr())
    }
    
    func getAmountWithCurrency() -> String {
        return sendProvider.getAmountStr()
    }
    
    func getAmountWithoutCurrency() -> String {
        return sendProvider.getAmountWithoutCurrencyStr()
    }
    
    func isFormValid() -> Bool {
        return !sendProvider.amount.isZero
    }
    
    func isValidAmount(_ amount: String) -> Bool {
        return amount.isEmpty || amount == Locale.current.decimalSeparator || amount.isValidDecimal()
    }
    
    func setAmount(_ amount: String) {
        let decimal = amount.decimalValue()
        sendProvider.amount = decimal
        output.updateConvertedAmount(sendProvider.getAmountInTransactionCurrencyStr())
    }
    
    func createAccountsDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountsProvider.getAllAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts)
        accountsManager.setCollectionView(collectionView)
        accountsDataManager = accountsManager
    }
    
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate) {
        accountsDataManager.delegate = delegate
    }
    
}


// MARK: - Private methods

extension SendInteractor {
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index{$0 == account}!
    }
    
    private func setInitialAccount(account: Account) {
        self.sendProvider.selectedAccount = account
    }
}
