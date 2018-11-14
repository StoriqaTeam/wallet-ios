//
//  SendPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendPresenter {
    
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
        view.viewController.setWhiteNavigationBarButtons()
        interactor.updateState()
        interactor.setAddress(address)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView)
        accountsDataManager = accountsManager
        accountsDataManager.delegate = self
    }
    
    func configureCollections() {
        let index = interactor.getAccountIndex()
        accountsDataManager.scrollTo(index: index)
    }
    
    func isValidAmount(_ amount: String) -> Bool {
        return interactor.isValidAmount(amount)
    }
    
    func amountChanged(_ amount: String) {
        interactor.setAmount(amount)
    }
    
    func amountDidBeginEditing() {
        let amount = interactor.getAmount()
        let currency = interactor.getCurrency()
        let formatted = getStringAmountWithoutCurrency(amount: amount, currency: currency)
        view.setAmount(formatted)
    }
    
    func amountDidEndEditing() {
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
        let fee = interactor.getFee()
        let currency = interactor.getCurrency()
        let amountString = getStringFrom(amount: amount, currency: currency)
        let feeString = getStringFrom(amount: fee, currency: currency)
        let address = interactor.getAddress()
        let confirmTxBlock = { [weak self] in
            self?.storiqaLoader.startLoader()
            self?.interactor.sendTransaction()
        }
        
        router.showConfirm(address: address,
                           amount: amountString,
                           fee: feeString,
                           confirmTxBlock: confirmTxBlock,
                           from: view.viewController)
    }
    
}


// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {
    func updateAddressIsValid(_ valid: Bool) {
        view.setAddressError(valid ? nil : "Addres is invalid")
    }
    
    func updateAccounts(accounts: [Account], index: Int) {
        accountsDataManager?.updateAccounts(accounts)
        accountsDataManager?.scrollTo(index: index)
        view.updatePagesCount(accounts.count)
        view.setNewPage(index)
    }
    
    func updateAmount(_ amount: Decimal, currency: Currency) {
        let amountString = getStringFrom(amount: amount, currency: currency)
        view.setAmount(amountString)
    }
    
    func updatePaymentFee(_ fee: Decimal) {
        let currency = interactor.getCurrency()
        let formatted = currencyFormatter.getStringFrom(amount: fee, currency: currency)
        view.setPaymentFee(formatted)
    }
    
    func updatePaymentFees(count: Int, selected: Int) {
        view.setPaymentFee(count: count, value: selected)
    }
    
    func updateMedianWait(_ wait: String) {
        view.setMedianWait(wait)
    }
    
    func updateTotal(_ total: Decimal, currency: Currency) {
        let totalAmountString = getStringFrom(amount: total, currency: currency)
        view.setSubtotal(totalAmountString)
    }
    
    func updateIsEnoughFunds(_ enough: Bool) {
        view.setEnoughFundsErrorHidden(enough)
    }
    
    func updateFormIsValid(_ valid: Bool) {
        view.setButtonEnabled(valid)
    }
    
    func sendTxFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showConfirmFailed(message: message, from: view.viewController)
    }
    
    func sendTxSucceed() {
        storiqaLoader.stopLoader()
        router.showConfirmSucceed(popUpDelegate: self, from: view.viewController)
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
        interactor.setCurrentAccount(index: newIndex)
        interactor.setAddress(address)
        view.setNewPage(newIndex)
    }
}


// MARK: - PopUpRegistrationSuccessVMDelegate

extension SendPresenter: PopUpSendConfirmSuccessVMDelegate {
    func okButtonPressed() {
        interactor.clearBuilder()
        interactor.updateState()
        address = ""
        view.setScannedAddress("")
    }
}


// MARK: - Private methods

extension SendPresenter {
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setWhiteNavigationBar(title: "send".localized())
    }
    
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.accountsCollectionFlowLayout
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = deviceLayout.spacing
        flowLayout.itemSize = deviceLayout.size
        flowLayout.sectionInset = UIEdgeInsets(top: 0,
                                               left: deviceLayout.spacing * 2,
                                               bottom: 0,
                                               right: deviceLayout.spacing * 2)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
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
