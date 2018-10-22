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
    
    private let accountsProvider: AccountsProviderProtocol
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let sendTransactionBuilder: SendProviderBuilderProtocol
    private var sendProvider: SendTransactionProviderProtocol
    
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
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getSelectedAccountCurrency() -> Currency {
        return sendProvider.selectedAccount.currency
    }
    
    func getAccountIndex() -> Int {
        let account = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: account)
        return index
    }
    
    func getAccountsCount() -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.count
    }
    
    func getTransactionBuilder() -> SendProviderBuilderProtocol {
        return sendTransactionBuilder
    }
    
    func setCurrentAccountWith(index: Int) {
        let currentIndex = getAccountIndex()
        guard currentIndex != index else { return }
        
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        let account = allAccounts[index]
        sendTransactionBuilder.set(account: account)
        output.updateAmount()
        output.updateConvertedAmount()
    }
    
    func setReceiverCurrency(_ currency: Currency) {
        sendTransactionBuilder.setReceiverCurrency(currency)
        output.updateAmount()
        output.updateConvertedAmount()
    }
    
    func isFormValid() -> Bool {
        return !sendProvider.amount.isZero
    }
    
    func isValidAmount(_ amount: String) -> Bool {
        return amount.isEmpty || amount == Locale.current.decimalSeparator || amount.isValidDecimal()
    }
    
    func setAmount(_ amount: String) {
        let decimal = amount.decimalValue()
        sendTransactionBuilder.set(cryptoAmount: decimal)
        output.updateConvertedAmount()
    }
    
    func getAmount() -> Decimal? {
        return sendProvider.amount
    }
    
    func getReceiverCurrency() -> Currency {
        return sendProvider.receiverCurrency
    }
    
    func getConvertedAmount() -> Decimal {
        return sendProvider.getConvertedAmount()
    }
    
    func updateTransactionProvider() {
        sendProvider = sendTransactionBuilder.build()
    }
    
}


// MARK: - Private methods

extension SendInteractor {
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account }!
    }
    
    private func setInitialAccount(account: Account) {
        sendTransactionBuilder.set(account: account)
    }
}
