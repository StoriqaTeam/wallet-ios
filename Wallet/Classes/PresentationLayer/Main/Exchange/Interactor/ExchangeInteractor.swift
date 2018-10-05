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
    
    private let accountWatcher: CurrentAccountWatcherProtocol
    private let accountsProvider: AccountsProviderProtocol
    private let converterFactory: CurrecncyConverterFactoryProtocol
    private let feeWaitProvider: PaymentFeeAndWaitProviderProtocol
    private var currencyConverter: CurrencyConverterProtocol!
    private var accountsDataManager: AccountsDataManager!
    private var accountsTableDataManager: AccountsTableDataManager!
    private var recepientAccount: AccountDisplayable! {
        didSet { updateConverter() }
    }
    private var amount: Decimal
    private var paymentFee: Decimal
    private var recepientAccounts: [AccountDisplayable]!
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol,
         feeWaitProvider: PaymentFeeAndWaitProviderProtocol) {
        self.accountWatcher = accountWatcher
        self.accountsProvider = accountsProvider
        self.converterFactory = converterFactory
        self.feeWaitProvider = feeWaitProvider
        
        // Default values
        amount = 0
        paymentFee = 0
        recepientAccounts = updateRecepientAccounts()
        recepientAccount = recepientAccounts.first!
        
        loadPaymentFees()
        updateConverter()
    }
}


// MARK: - ExchangeInteractorInput

extension ExchangeInteractor: ExchangeInteractorInput {
    
    func createAccountsDataManager(with collectionView: UICollectionView) {
        let allAccounts = accountsProvider.getAllAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts)
        accountsManager.setCollectionView(collectionView, cellType: .small)
        accountsDataManager = accountsManager
    }
    
    func setAccountsDataManagerDelegate(_ delegate: AccountsDataManagerDelegate) {
        accountsDataManager.delegate = delegate
    }
    
    func createAccountsTableDataManager(with tableView: UITableView) {
        let currencyFormatter = CurrencyFormatter()
        let accountsManager = AccountsTableDataManager(currencyFormatter: currencyFormatter)
        accountsManager.setTableView(tableView)
        accountsTableDataManager = accountsManager
    }
    
    func setAccountsTableDataManagerDelegate(_ delegate: AccountsTableDataManagerDelegate) {
        accountsTableDataManager.delegate = delegate
    }
    
    func scrollCollection() {
        let currentAccount = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: currentAccount)
        accountsDataManager.scrollTo(index: index)
    }
    
    func prepareAccountsTable() {
        accountsTableDataManager.accounts = recepientAccounts
    }
    
    func getAccountsTableHeight() -> CGFloat {
        return accountsTableDataManager.calculateHeight()
    }
    
    func getAccountsCount() -> Int {
        return accountsProvider.getAllAccounts().count
    }
    
    func getPaymentFeeValuesCount() -> Int {
        return feeWaitProvider.getValuesCount()
    }
    
    func getAmount() -> Decimal {
        return amount
    }
    
    func getAccountCurrency() -> Currency {
        return accountWatcher.getAccount().currency
    }
    
    func getRecepientCurrency() -> Currency {
        return recepientAccount.currency
    }
    
    func setCurrentAccount(index: Int) {
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        recepientAccounts = updateRecepientAccounts()
        loadPaymentFees()
        
        updateFeeCount()
        updateRecepientAccount()
        updateConvertedAmount()
        updateFeeAndWait()
        updateTotal()
    }
    
    func setRecepientAccount(index: Int) {
        recepientAccount = recepientAccounts[index]
        
        updateRecepientAccount()
        updateAmount()
        updateConvertedAmount()
        updateTotal()
    }
    
    func setAmount(_ amount: Decimal) {
        self.amount = amount
        
        updateConvertedAmount()
        updateTotal()
    }
    
    func setPaymentFee(index: Int) {
        paymentFee = feeWaitProvider.getFee(index: index)
        
        updateFeeAndWait()
        updateTotal()
    }
    
}


// MARK: - Private methods

extension ExchangeInteractor {
    
    private func resolveAccountIndex(account: AccountDisplayable) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index { $0 == account }!
    }
    
    private func updateRecepientAccounts() -> [AccountDisplayable] {
        let allAccounts = accountsProvider.getAllAccounts()
        let filtered = allAccounts.filter({
            $0.type != accountWatcher.getAccount().type
        })
        return filtered
    }
    
    private func loadPaymentFees() {
        let currency = accountWatcher.getAccount().currency
        feeWaitProvider.updateSelectedForCurrency(currency)
        paymentFee = feeWaitProvider.getFee(index: 0)
    }
    
    
    private func calculateTotalAmount() -> Decimal {
        let accountCurrency = accountWatcher.getAccount().currency
        let total: Decimal
        
        if !amount.isZero {
            let converted = currencyConverter.convert(amount: amount, to: accountCurrency)
            total = converted + paymentFee
        } else {
            total = 0
        }
        
        return total
    }
    
    private func isEnoughFunds(total: Decimal) -> Bool {
        //TODO: balancer
        //TODO: amount in decimal
        let available = accountWatcher.getAccount().cryptoAmount.decimalValue()
        let isEnoughFunds = total.isLessThanOrEqualTo(available)
        return isEnoughFunds
    }
    
    private func updateConverter() {
        let currency = recepientAccount.currency
        currencyConverter = converterFactory.createConverter(from: currency)
    }
    
}


// MARK: - Updaters

extension ExchangeInteractor {

    private func updateRecepientAccount() {
        if !recepientAccounts.contains(where: { $0.type == recepientAccount.type }) {
            recepientAccount = recepientAccounts.first!
        }
        
        output.updateRecepientAccount(recepientAccount)
    }
    
    private func updateAmount() {
        let currency = recepientAccount.currency
        output.updateAmount(amount, currency: currency)
    }
    
    private func updateConvertedAmount() {
        let account = accountWatcher.getAccount()
        output.convertAmount(amount, to: account.currency)
    }
    
    private func updateFeeAndWait() {
        let wait = feeWaitProvider.getWait(fee: paymentFee)
        
        output.updatePaymentFee(paymentFee)
        output.updateMedianWait(wait)
    }
    
    private func updateFeeCount() {
        let count = feeWaitProvider.getValuesCount()
        output.updatePaymentFees(count: count, selected: 0)
    }
    
    private func updateTotal() {
        let accountCurrency = accountWatcher.getAccount().currency
        let total = calculateTotalAmount()
        let isEnough = isEnoughFunds(total: total)
        let formIsValid = isEnough && !amount.isZero
        
        output.updateTotal(total, accountCurrency: accountCurrency)
        output.updateIsEnoughFunds(isEnough)
        output.updateFormIsValid(formIsValid)
    }
    
}
