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
    private let cryptoAddressResolver: CryptoAddressResolverProtocol
    private let sendTransactionService: SendTransactionServiceProtocol
    private let feeLoader: FeeLoaderProtocol
    
    private var sendProvider: SendTransactionProviderProtocol
    private var accountsUpadteChannelInput: AccountsUpdateChannel?
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol,
         accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         cryptoAddressResolver: CryptoAddressResolverProtocol,
         sendTransactionService: SendTransactionServiceProtocol,
         feeLoader: FeeLoaderProtocol) {
        
        self.accountsProvider = accountsProvider
        self.sendTransactionBuilder = sendTransactionBuilder
        self.accountWatcher = accountWatcher
        self.cryptoAddressResolver = cryptoAddressResolver
        self.sendProvider = sendTransactionBuilder.build()
        self.sendTransactionService = sendTransactionService
        self.feeLoader = feeLoader
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
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadteChannelInput = channel
    }
}


// MARK: - SendInteractorInput

extension SendInteractor: SendInteractorInput {
    
    func setAddress(_ address: String) {
        setAddress(address, updateFeesIfNeeded: true)
    }
    
    func getAddress() -> String {
        return sendProvider.receiverAddress
    }
    
    func getAccounts() -> [Account] {
        return accountsProvider.getAllAccounts()
    }
    
    func getAccountsCount() -> Int {
        let allAccounts = accountsProvider.getAllAccounts()
        return allAccounts.count
    }
    
    func getAccountIndex() -> Int {
        let account = accountWatcher.getAccount()
        let index = resolveAccountIndex(account: account)
        return index
    }
    
    func getAmount() -> Decimal? {
        return sendProvider.amount
    }
    
    func getFee() -> Decimal? {
        let estimatedFee = sendProvider.getFeeAndWait()
        return estimatedFee.fee
    }
    
    func getTotal() -> Decimal {
        return sendProvider.getSubtotal()
    }
    
    func getCurrency() -> Currency {
        return accountWatcher.getAccount().currency
    }
    
    func setAmount(_ amount: Decimal) {
        sendTransactionBuilder.set(cryptoAmount: amount)
        
        updateTotal()
    }
    
    func setCurrentAccount(index: Int, receiverAddress: String) {
        let currentIndex = getAccountIndex()
        guard currentIndex != index else { return }
        
        let allAccounts = accountsProvider.getAllAccounts()
        let account = allAccounts[index]
        accountWatcher.setAccount(account)
        
        updateState(receiverAddress: receiverAddress)
    }
    
    func setPaymentFee(index: Int) {
        sendTransactionBuilder.setPaymentFee(index: index)
        
        updateFeeAndWait()
        updateTotal()
    }
    
    func getTransactionBuilder() -> SendProviderBuilderProtocol {
        return sendTransactionBuilder
    }
    
    func updateState(receiverAddress: String) {
        let account = accountWatcher.getAccount()
        let previousCurrency = sendProvider.selectedAccount.currency

        sendTransactionBuilder.set(account: account)
        setAddress(receiverAddress, updateFeesIfNeeded: false)
        updateAmount()
        updateFeeCount()
        updateFeeAndWait()
        
        let address = sendProvider.receiverAddress
        if account.currency != previousCurrency && !address.isEmpty {
            updateFees()
        }
        
        updateTotal()
    }
    
    func startObservers() {
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
    }
    
    func setScannedDelegate(_ delegate: QRScannerDelegate) {
        sendTransactionBuilder.setScannedDelegate(delegate)
    }
    
    func sendTransaction() {
        let txToSend = sendProvider.createTransaction()
        let account = sendProvider.selectedAccount
        let fromAccount = account.id.lowercased()
        
        sendTransactionService.sendTransaction(
            transaction: txToSend,
            fromAccount: fromAccount) { [weak self] (result) in
                switch result {
                case .success:
                    self?.output.sendTxSucceed()
                case .failure(let error):
                    if let error = error as? SendNetworkError,
                        case .exceededDayLimit(let limit, let currency) = error {
                        self?.output.exceededDayLimit(limit: limit, currency: currency)
                        return
                    }
                    self?.output.sendTxFailed(message: error.localizedDescription)
                }
        }
    }
    
    func clearBuilder() {
        sendTransactionBuilder.clear()
        sendProvider = sendTransactionBuilder.build()
    }
    
}


// MARK: - Private methods

extension SendInteractor {
    private func setAddress(_ address: String, updateFeesIfNeeded: Bool) {
        let currency = sendProvider.selectedAccount.currency
        
        guard !address.isEmpty else {
            sendTransactionBuilder.setAddress("")
            output.updateAddressIsValid(true)
            output.updateFormIsValid(false)
            updateEmptyFees()
            return
        }
        
        guard let addressCurrency = cryptoAddressResolver.resove(address: address) else {
            sendTransactionBuilder.setAddress("")
            output.updateAddressIsValid(false)
            output.updateFormIsValid(false)
            updateEmptyFees()
            return
        }
        
        let newAddress: String
        
        switch addressCurrency {
        case .eth where currency == .eth || currency == .stq:
            newAddress = address
        case .btc where currency == .btc:
            newAddress = address
        default:
            newAddress = ""
            updateEmptyFees()
        }
        
        let previousAddress = sendProvider.receiverAddress
        sendTransactionBuilder.setAddress(newAddress)
        
        if updateFeesIfNeeded && !newAddress.isEmpty && newAddress != previousAddress {
            updateFees()
        }
        
        updateAddressValidity()
    }
    
    private func updateFees() {
        let currency = sendProvider.selectedAccount.currency
        let accountAddress = sendProvider.receiverAddress
        
        guard !accountAddress.isEmpty else {
            return
        }
        
        output.setFeeUpdating(true)
        sendTransactionBuilder.setFees(nil)
        
        feeLoader.getFees(currency: currency, accountAddress: accountAddress) { [weak self] (result) in
            switch result {
            case .success(let fees):
                self?.sendTransactionBuilder.setFees(fees)
                
            case .failure(let error):
                if case SendNetworkError.wrongCurrency(let message) = error {
                    self?.output.setWrongCurrency(message: message)
                }
            }
            
            self?.output.setFeeUpdating(false)
            self?.updateFeeCount()
            self?.updateFeeAndWait()
            self?.updateTotal()
        }
        
    }
    
    private func feeDidUpdate() {
        updateFeeCount()
        updateFeeAndWait()
        updateTotal()
    }
    
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
    
    private func isFormValid() -> Bool {
        let isZeroAmount = sendProvider.amount.isZero
        let isEmptyAddress = sendProvider.receiverAddress.isEmpty
        let hasFee = sendProvider.paymentFee != nil
        
        return !isZeroAmount && !isEmptyAddress && hasFee && sendProvider.isEnoughFunds()
    }
    
    private func updateAddressValidity() {
        let isValidAddress = !sendProvider.receiverAddress.isEmpty
        output.updateAddressIsValid(isValidAddress)
        
        let formIsValid = isFormValid()
        output.updateFormIsValid(formIsValid)
    }
    
    private func updateAmount() {
        let account = accountWatcher.getAccount()
        let currency = account.currency
        let amount = sendProvider.amount
        output.updateAmount(amount, currency: currency)
    }
    
    private func updateFeeAndWait() {
        let feeWait = sendProvider.getFeeAndWait()
        output.updatePaymentFee(feeWait.fee)
        output.updateMedianWait(feeWait.wait)
    }
    
    private func updateFeeCount() {
        let count = sendProvider.getFeeWaitCount()
        let index = sendProvider.getFeeIndex()
        output.updatePaymentFees(count: count, selected: index)
    }
    
    private func updateEmptyFees() {
        sendTransactionBuilder.setFees(nil)
        output.updatePaymentFee(nil)
        output.updateMedianWait("")
        output.updatePaymentFees(count: 0, selected: 0)
    }
    
    private func updateTotal() {
        let accountCurrency = accountWatcher.getAccount().currency
        let total = sendProvider.getSubtotal()
        let formIsValid = isFormValid()
        let isEnough = sendProvider.isEnoughFunds()
        let hasAmount = !sendProvider.amount.isZero
        
        output.updateTotal(total, currency: accountCurrency)
        output.updateIsEnoughFunds(!hasAmount || isEnough)
        output.updateFormIsValid(formIsValid)
    }
    
}
