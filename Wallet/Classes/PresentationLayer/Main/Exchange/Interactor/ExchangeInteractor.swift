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
    private var currencyConverter: CurrencyConverterProtocol!
    private var accountsDataManager: AccountsDataManager!
    private var recepientAccount: Account! {
        didSet { updateConverter() }
    }
    private var amount: Decimal
    private var paymentFee: Decimal
    private var recepientAccounts: [Account]!
    
    //FIXME: stub
    private var feeWait: [Decimal: Decimal] = [1: 10,
                                               2: 9,
                                               3: 8,
                                               4: 7,
                                               5: 6,
                                               6: 5]
    
    init(accountWatcher: CurrentAccountWatcherProtocol,
         accountsProvider: AccountsProviderProtocol,
         converterFactory: CurrecncyConverterFactoryProtocol) {
        self.accountWatcher = accountWatcher
        self.accountsProvider = accountsProvider
        self.converterFactory = converterFactory
        
        // Default values
        amount = 0
        paymentFee = 0
        recepientAccounts = updateRecepientAccounts()
        recepientAccount = recepientAccounts.first!
        
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
    
    func scrollCollection() {
        let currentAccount = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: currentAccount)
        accountsDataManager.scrollTo(index: index)
    }
    
    func getAccountsCount() -> Int {
        return accountsProvider.getAllAccounts().count
    }
    
    func getPaymentFeeValuesCountCount() -> Int {
        return feeWait.count
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
    
    func getRecepientAccounts() -> [Account] {
        return recepientAccounts
    }
    
    func setCurrentAccount(index: Int) {
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        recepientAccounts = updateRecepientAccounts()
        loadPaymentFees()
        
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
        let paymentFeeValues = Array(feeWait.keys).sorted()
        paymentFee = paymentFeeValues[index]
        
        updateFeeAndWait()
        updateTotal()
    }
    
}


// MARK: - Private methods

extension ExchangeInteractor {
    
    private func resolveAccountIndex(account: Account) -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.index{$0 == account}!
    }
    
    private func updateRecepientAccounts() -> [Account] {
        let allAccounts = accountsProvider.getAllAccounts()
        let filtered = allAccounts.filter({
            $0.type != accountWatcher.getAccount().type
        })
        return filtered
    }
    
    private func loadPaymentFees() {
        //TODO: update fees dictionary
        //FIXME: - stub
        switch accountWatcher.getAccount().currency {
        case .stq:
            feeWait = [1: 10, 2: 9, 3: 8, 4: 7, 5: 6, 6: 5]
        case .btc:
            feeWait = [10: 101, 20: 91, 30: 81, 40: 71, 50: 61, 60: 51]
        case .eth:
            feeWait = [11: 102, 12: 92, 13: 82, 14: 72, 15: 62, 16: 52]
        case .fiat:
            feeWait = [21: 103, 22: 93, 23: 83, 24: 73, 25: 63, 26: 53]
        }
        
        let paymentFeeValues = Array(feeWait.keys).sorted()
        paymentFee = paymentFeeValues.first!
    }
    
    
    private func calcTotal() -> Decimal {
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
        let count = feeWait.count
        let paymentFeeValues = Array(feeWait.keys).sorted()
        let step = Int(paymentFeeValues.firstIndex(of: paymentFee)!)
        let wait = feeWait[paymentFee]!
        
        output.updatePaymentFees(count: count, selected: step)
        output.updatePaymentFee(paymentFee)
        output.updateMedianWait(wait)
    }
    
    private func updateTotal() {
        let accountCurrency = accountWatcher.getAccount().currency
        
        let total = calcTotal()
        let isEnough = isEnoughFunds(total: total)
        let formIsValid = isEnough && !amount.isZero
        output.updateTotal(total, accountCurrency: accountCurrency)
        output.updateIsEnoughFunds(isEnough)
        output.updateFormIsValid(formIsValid)
        
    }
    
}
