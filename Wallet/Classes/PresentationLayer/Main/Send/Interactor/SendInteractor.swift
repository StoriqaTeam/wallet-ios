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
    private let sendProvider: SendTransactionBuilderProtocol
    
    init(sendProvider: SendTransactionBuilderProtocol, accountsProvider: AccountsProviderProtocol, account: Account? = nil) {
        self.accountsProvider = accountsProvider
        self.sendProvider = sendProvider
        //TODO: если нет ни одного счёта?
        self.sendProvider.selectedAccount = account ?? accountsProvider.getAllAccounts().first!
    }
}


// MARK: - SendInteractorInput

extension SendInteractor: SendInteractorInput {
    
    func setCurrentAccountWith(index: Int) {
        let allAccounts = accountsProvider.getAllAccounts()
        sendProvider.selectedAccount = allAccounts[index]
        
        output.updateAmount(sendProvider.getAmountStr())
        output.updateConvertedAmount(sendProvider.getAmountInTransactionCurrencyStr())
    }
    
    func scrollCollection() {
        let index = resolveAccountIndex(account: sendProvider.selectedAccount)
        accountsDataManager.scrollTo(index: index)
    }
    
    func setReceiverCurrency(_ currency: Currency) {
        sendProvider.receiverCurrency = currency
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
}
