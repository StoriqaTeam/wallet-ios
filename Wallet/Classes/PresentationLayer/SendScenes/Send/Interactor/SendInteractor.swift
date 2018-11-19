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
    private var sendProvider: SendTransactionProviderProtocol
    private var accountsUpadteChannelInput: AccountsUpdateChannel?
    private var feeUpadteChannelInput: FeeUpdateChannel?
    
    init(sendTransactionBuilder: SendProviderBuilderProtocol,
         accountsProvider: AccountsProviderProtocol,
         accountWatcher: CurrentAccountWatcherProtocol,
         cryptoAddressResolver: CryptoAddressResolverProtocol,
         sendTransactionService: SendTransactionServiceProtocol) {
        
        self.accountsProvider = accountsProvider
        self.sendTransactionBuilder = sendTransactionBuilder
        self.accountWatcher = accountWatcher
        self.cryptoAddressResolver = cryptoAddressResolver
        self.sendProvider = sendTransactionBuilder.build()
        self.sendTransactionService = sendTransactionService
        
        let account = accountWatcher.getAccount()
        sendTransactionBuilder.set(account: account)
    }
    
    deinit {
        self.accountsUpadteChannelInput?.removeObserver(withId: self.objId)
        self.accountsUpadteChannelInput = nil
        self.feeUpadteChannelInput?.removeObserver(withId: self.objId)
        self.feeUpadteChannelInput = nil
    }
    
    // MARK: - Channels
    
    private lazy var objId: String = {
        let identifier = "\(type(of: self)):\(String(format: "%p", unsafeBitCast(self, to: Int.self)))"
        return identifier
    }()
    
    func setAccountsUpdateChannelInput(_ channel: AccountsUpdateChannel) {
        self.accountsUpadteChannelInput = channel
    }
    
    func setFeeUpdateChannelInput(_ channel: FeeUpdateChannel) {
        self.feeUpadteChannelInput = channel
    }
}


// MARK: - SendInteractorInput

extension SendInteractor: SendInteractorInput {
    
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
        return sendProvider.paymentFee
    }
    
    func getCurrency() -> Currency {
        return accountWatcher.getAccount().currency
    }
    
    func setAmount(_ amount: Decimal) {
        sendTransactionBuilder.set(cryptoAmount: amount)
        
        updateTotal()
    }
    
    func setCurrentAccount(index: Int) {
        let currentIndex = getAccountIndex()
        guard currentIndex != index else { return }
        
        let allAccounts = accountsProvider.getAllAccounts()
        accountWatcher.setAccount(allAccounts[index])
        let account = allAccounts[index]
        sendTransactionBuilder.set(account: account)
        
        updateAmount()
        updateFeeCount()
        updateFeeAndWait()
        updateTotal()
    }
    
    func setPaymentFee(index: Int) {
        sendTransactionBuilder.setPaymentFee(index: index)
        
        updateFeeAndWait()
        updateTotal()
    }
    
    func setAddress(_ address: String) {
        let currency = sendProvider.selectedAccount.currency
        
        guard !address.isEmpty else {
            sendTransactionBuilder.setAddress("")
            output.updateAddressIsValid(true)
            output.updateFormIsValid(false)
            return
        }
        
        guard let addressCurrency = cryptoAddressResolver.resove(address: address) else {
            sendTransactionBuilder.setAddress("")
            output.updateAddressIsValid(false)
            output.updateFormIsValid(false)
            return
        }
        
        switch addressCurrency {
        case .eth where currency == .eth || currency == .stq:
            sendTransactionBuilder.setAddress(address)
        case .btc where currency == .btc:
            sendTransactionBuilder.setAddress(address)
        default:
            sendTransactionBuilder.setAddress("")
        }
        
        updateAddressValidity()
    }
    
    func getTransactionBuilder() -> SendProviderBuilderProtocol {
        return sendTransactionBuilder
    }
    
    func updateState() {
        let account = accountWatcher.getAccount()
        sendTransactionBuilder.set(account: account)
        
        updateAmount()
        updateFeeCount()
        updateFeeAndWait()
        updateTotal()
    }
    
    func startObservers() {
        let accountsObserver = Observer<[Account]>(id: self.objId) { [weak self] (accounts) in
            self?.accountsDidUpdate(accounts)
        }
        self.accountsUpadteChannelInput?.addObserver(accountsObserver)
        
        let feeObserver = Observer<[Fee]>(id: self.objId) { [weak self] _ in
            self?.feeDidUpdate()
        }
        self.feeUpadteChannelInput?.addObserver(feeObserver)
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
    private func feeDidUpdate() {
        sendProvider.updateFees()
        
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
