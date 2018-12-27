//
//  SendPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendPresenter {
    
    typealias LocalizedStrings = Strings.Send
    
    weak var view: SendViewInput!
    weak var output: SendModuleOutput?
    var interactor: SendInteractorInput!
    var router: SendRouterInput!
    weak var mainTabBar: UITabBarController!
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let currencyImageProvider: CurrencyImageProviderProtocol
    private let accountDisplayer: AccountDisplayerProtocol
    private var accountsDataManager: AccountsDataManager!
    
    private var storiqaLoader: StoriqaLoader!
    private var address: String = ""
    private var isEditingAmount = false
    private var feesError: String?
    
    init(currencyFormatter: CurrencyFormatterProtocol,
         currencyImageProvider: CurrencyImageProviderProtocol,
         accountDisplayer: AccountDisplayerProtocol) {
        self.currencyFormatter = currencyFormatter
        self.currencyImageProvider = currencyImageProvider
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - SendViewOutput

extension SendPresenter: SendViewOutput {
    
    func viewIsReady() {
        let numberOfPages = interactor.getAccountsCount()
        configureNavBar()
        view.setupInitialState(numberOfPages: numberOfPages)
        interactor.startObservers()
        addLoader()
    }
    
    func viewWillAppear() {
        interactor.updateState(receiverAddress: address)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView, cellType: .small)
        accountsDataManager = accountsManager
        accountsDataManager.delegate = self
    }
    
    func configureCollections() {
        let index = interactor.getAccountIndex()
        accountsDataManager.scrollTo(index: index)
    }
    
    func isValidAmount(_ amount: String) -> Bool {
        return amount.isEmpty || amount == "." || amount == "," || amount.isValidDecimal()
    }
    
    func amountChanged(_ amount: String) {
        interactor.setAmount(amount.decimalValue())
    }
    
    func amountDidBeginEditing() {
        isEditingAmount = true
        let amount = interactor.getAmount()
        let currency = interactor.getCurrency()
        let formatted = getStringAmountWithoutCurrency(amount: amount, currency: currency)
        view.setAmount(formatted)
    }
    
    func amountDidEndEditing() {
        isEditingAmount = false
        let amount = interactor.getAmount()
        let currency = interactor.getCurrency()
        let formatted = getStringFrom(amount: amount, currency: currency)
        view.setAmount(formatted)
    }
    
    func receiverAddressDidChange(_ address: String) {
        self.address = address
        interactor.setAddress(address)
    }
    
    func newFeeSelected(_ index: Int) {
        interactor.setPaymentFee(index: index)
    }
    
    func scanButtonPressed() {
        let builder = interactor.getTransactionBuilder()
        interactor.setScannedDelegate(self)
        router.showScanner(sendTransactionBuilder: builder, from: view.viewController)
    }
    
    func sendButtonPressed() {
        let amount = interactor.getAmount()
        let fee = interactor.getFee() ?? 0
        let total = interactor.getTotal()
        let currency = interactor.getCurrency()
        let amountString = getStringFrom(amount: amount, currency: currency)
        let feeString = getStringFrom(amount: fee, currency: currency)
        let totalString = getStringFrom(amount: total, currency: currency)
        let address = interactor.getAddress()
        let confirmTxBlock = { [weak self] in
            self?.storiqaLoader.startLoader()
            self?.interactor.sendTransaction()
        }
        
        router.showConfirm(address: address,
                           amount: amountString,
                           fee: feeString,
                           total: totalString,
                           confirmTxBlock: confirmTxBlock,
                           from: view.viewController)
    }
    
}


// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {
    func setWrongCurrency(message: String) {
        view.setAddressError(message)
    }
    
    func updateAddressIsValid(_ valid: Bool) {
        view.setAddressError(valid ? nil : LocalizedStrings.nonExistAddressTitle)
    }
    
    func updateAccounts(accounts: [Account], index: Int) {
        accountsDataManager?.updateAccounts(accounts)
        accountsDataManager?.scrollTo(index: index)
        view.updatePagesCount(accounts.count)
        view.setNewPage(index)
    }
    
    func updateAmount(_ amount: Decimal, currency: Currency) {
        let amountString: String = {
            if isEditingAmount {
                return getStringAmountWithoutCurrency(amount: amount, currency: currency)
            } else {
                return getStringFrom(amount: amount, currency: currency)
            }
        }()
        view.setAmount(amountString)
    }
    
    func updatePaymentFee(_ fee: Decimal?) {
        guard let fee = fee else {
            view.setPaymentFee("")
            return
        }
        
        let currency = interactor.getCurrency()
        let formatted = currencyFormatter.getStringFrom(amount: fee, currency: currency, maxFractionDigits: 8)
        view.setPaymentFee(formatted)
    }
    
    func updatePaymentFees(count: Int, selected: Int) {
        let hidden = count <= 1
        
        view.setPaymentFee(count: count, value: selected, enabled: !hidden)
        view.setPaymentFeeHidden(hidden)
    }
    
    func updateMedianWait(_ wait: String) {
        view.setMedianWait(wait)
    }
    
    func updateIsEnoughFunds(_ enough: Bool) {
        let message = !enough ? LocalizedStrings.notEnoughFundsErrorMessage : feesError
        view.setErrorMessage(message)
    }
    
    func updateFormIsValid(_ valid: Bool) {
        view.setButtonEnabled(valid)
    }
    
    func setFeeUpdating(_ isUpdating: Bool) {
        view.setFeeUpdateIndicator(hidden: !isUpdating)
        
        if isUpdating {
            view.setPaymentFee("")
            view.setMedianWait("")
            view.setPaymentFee(count: 0, value: 0, enabled: false)
        }
    }
    
    func sendTxFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showFailure(message: message, from: view.viewController)
    }
    
    func sendTxSucceed() {
        storiqaLoader.stopLoader()
        router.showConfirmSucceed(popUpDelegate: self, from: view.viewController)
    }
    
    func exceededDayLimit(limit: String, currency: Currency) {
        storiqaLoader.stopLoader()
        
        let limitStr = currencyFormatter.getStringFrom(amount: limit.decimalValue(), currency: currency)
        let message = String(format: LocalizedStrings.exceedDayLimitMessage, limitStr)
        
        router.showFailure(message: message, from: view.viewController)
    }
    
    func setFeesError(_ message: String?) {
        feesError = message
        view.setErrorMessage(message)
    }
}


// MARK: - SendModuleInput

extension SendPresenter: SendModuleInput {
    
    var viewController: UIViewController {
        return view.viewController
    }
    
    func present() {
        view.present()
    }
    
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - QRScannerDelegate

extension SendPresenter: QRScannerDelegate {
    
    func didScanAddress(_ address: String) {
        self.address = address
        interactor.setAddress(address)
        view.setScannedAddress(address)
    }
    
}

// MARK: - AccountsDataManagerDelegate

extension SendPresenter: AccountsDataManagerDelegate {
    func currentPageDidChange(_ newIndex: Int) {
        interactor.setCurrentAccount(index: newIndex, receiverAddress: address)
        view.setNewPage(newIndex)
    }
}


// MARK: - PopUpRegistrationSuccessVMDelegate

extension SendPresenter: PopUpSendConfirmSuccessVMDelegate {
    func okButtonPressed() {
        address = ""
        view.setScannedAddress("")
        interactor.clearBuilder()
        interactor.updateState(receiverAddress: address)
    }
}


// MARK: - Private methods

extension SendPresenter {
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setHidableNavigationBar(title: LocalizedStrings.screenTitle)
    }
    
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.flowLayout(type: .horizontalSmall)
        return deviceLayout
    }
    
    private func getStringFrom(amount: Decimal?, currency: Currency) -> String {
        guard let amount = amount, !amount.isZero else {
            return ""
        }
        
        let formatted = currencyFormatter.getStringFrom(amount: amount, currency: currency)
        return formatted
    }
    
    private func getStringAmountWithoutCurrency(amount: Decimal?, currency: Currency) -> String {
        guard let amount = amount, !amount.isZero else {
            return ""
        }
        
        let formatted = currencyFormatter.getStringWithoutCurrencyFrom(amount: amount, currency: currency)
        return formatted
    }
    
    private func addLoader() {
        guard let parentView = view.viewController.navigationController?.view else { return }
        storiqaLoader = StoriqaLoader(parentView: parentView)
    }
    
}
