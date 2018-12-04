//
//  ExchangePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangePresenter {
    
    weak var view: ExchangeViewInput!
    weak var output: ExchangeModuleOutput?
    var interactor: ExchangeInteractorInput!
    var router: ExchangeRouterInput!
    
    private let converterFactory: CurrencyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let accountDisplayer: AccountDisplayerProtocol
    private var accountsDataManager: AccountsDataManager!
    
    private var storiqaLoader: StoriqaLoader!
    private var isEditingAmount = false
    
    init(converterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountDisplayer: AccountDisplayerProtocol) {
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - ExchangeViewOutput

extension ExchangePresenter: ExchangeViewOutput {
    
    func viewIsReady() {
        let numberOfPages = interactor.getAccountsCount()
        view.setupInitialState(numberOfPages: numberOfPages)
        configureNavBar()
        addLoader()
        
        interactor.startObservers()
    }
    
    func viewWillAppear() {
        view.viewController.setWhiteNavigationBarButtons()
        interactor.updateState()
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
        let currency = interactor.getRecepientCurrency()
        let formatted = getStringAmountWithoutCurrency(amount: amount, currency: currency)
        view.setAmount(formatted)
    }
    
    func amountDidEndEditing() {
        isEditingAmount = false
        let amount = interactor.getAmount()
        let currency = interactor.getRecepientCurrency()
        let formatted = getStringFrom(amount: amount, currency: currency)
        view.setAmount(formatted)
    }
    
    func recepientAccountPressed() {
        let accounts = interactor.getRecepientAccounts()
        
        guard !accounts.isEmpty else {
            return
        }
        
        let builder = interactor.getTransactionBuilder()
        router.showRecepientAccountSelection(exchangeProviderBuilder: builder, from: view.viewController)
    }
    
    func exchangeButtonPressed() {
        let fromAccount = interactor.getAccountName()
        let toAccount = interactor.getRecepientAccountName()
        let currency = interactor.getRecepientCurrency()
        let decimalAmount = interactor.getAmount()
        let amountStr = currencyFormatter.getStringFrom(amount: decimalAmount, currency: currency)
        let confirmTxBlock = { [weak self] in
            self?.storiqaLoader.startLoader()
            self?.interactor.sendTransaction()
        }
        
        router.showConfirm(fromAccount: fromAccount,
                           toAccount: toAccount,
                           amount: amountStr,
                           confirmTxBlock: confirmTxBlock,
                           from: view.viewController)
    }
    
}


// MARK: - ExchangeInteractorOutput

extension ExchangePresenter: ExchangeInteractorOutput {
    
    func updateOrder(time: Int?) {
        guard let elapsedTime = time else {
            view.updateExpiredTimeLabel("")
            return
        }
        
        let elapsedString = timeFormatted(elapsedTime)
        view.updateExpiredTimeLabel(elapsedString)
    }
    
    func updateRateFor(oneUnit: Decimal?, fromCurrency: Currency, toCurrency: Currency) {
        guard let oneUnitRate = oneUnit else {
            view.updateRateLabel(text: "")
            return
        }
        
        let fromStr = currencyFormatter.getStringFrom(amount: 1, currency: fromCurrency)
        let rateStr = currencyFormatter.getStringFrom(amount: oneUnitRate, currency: toCurrency)
        
        let outString = "\(fromStr) = \(rateStr)"
        view.updateRateLabel(text: outString)
    }
    
    
    func updateAccounts(accounts: [Account], index: Int) {
        accountsDataManager?.updateAccounts(accounts)
        accountsDataManager?.scrollTo(index: index)
        view.updatePagesCount(accounts.count)
        view.setNewPage(index)
    }
    
    func updateRecepientAccount(_ account: Account?) {
        guard let account = account else {
            view.setRecepientAccount("No accounts available")
            view.setRecepientBalance("")
            return
        }
        
        let balance = accountDisplayer.cryptoAmount(for: account)
        
        view.setRecepientAccount(account.name)
        view.setRecepientBalance("Balance: \(balance)")
    }
    
    func exchangeRateError(_ error: Error) {
        view.showEchangeRateError(message: error.localizedDescription)
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
    
    func updateTotal(_ total: Decimal, currency: Currency) {
        let totalAmountString = currencyFormatter.getStringFrom(amount: total, currency: currency)
        view.setSubtotal(totalAmountString)
    }
    
    func updateIsEnoughFunds(_ enough: Bool) {
        view.setErrorHidden(enough)
    }
    
    func updateFormIsValid(_ valid: Bool) {
        view.setButtonEnabled(valid)
    }
    
    func exchangeTxAmountOutOfLimit(min: String, max: String, currency: Currency) {
        storiqaLoader.stopLoader()
        
        let minAmountStr = currencyFormatter.getStringFrom(amount: min.decimalValue(), currency: currency)
        let maxAmountStr = currencyFormatter.getStringFrom(amount: max.decimalValue(), currency: currency)
        // FIXME: msg
        let message = "Amount should be between \(minAmountStr) and \(maxAmountStr)"
        
        router.showConfirmFailed(popUpDelegate: self, message: message, from: view.viewController)
    }
    
    func exceededDayLimit(limit: String, currency: Currency) {
        storiqaLoader.stopLoader()
        
        let limitStr = currencyFormatter.getStringFrom(amount: limit.decimalValue(), currency: currency)
        // FIXME: msg
        let message = "Dayly limit for the account \(limitStr) exceeded"
        
        router.showConfirmFailed(popUpDelegate: self, message: message, from: view.viewController)
    }
    
    func exchangeTxFailed(message: String) {
        storiqaLoader.stopLoader()
        router.showConfirmFailed(popUpDelegate: self, message: message, from: view.viewController)
    }
    
    func exchangeTxSucceed() {
        storiqaLoader.stopLoader()
        router.showConfirmSucceed(popUpDelegate: self, from: view.viewController)
    }

}


// MARK: - ExchangeModuleInput

extension ExchangePresenter: ExchangeModuleInput {
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


// MARK: - AccountsDataManagerDelegate

extension ExchangePresenter: AccountsDataManagerDelegate {
    func currentPageDidChange(_ newIndex: Int) {
        interactor.setCurrentAccount(index: newIndex)
        view.setNewPage(newIndex)
    }
}


// MARK: - PopUpExchangeFailedVMDelegate

extension ExchangePresenter: PopUpExchangeFailedVMDelegate {
    func retry() {
        storiqaLoader.startLoader()
        interactor.sendTransaction()
    }
}


// MARK: - PopUpRegistrationSuccessVMDelegate

extension ExchangePresenter: PopUpSendConfirmSuccessVMDelegate {
    func okButtonPressed() {
        interactor.clearBuilder()
        interactor.updateState()
    }
}


// MARK: - Private methods

extension ExchangePresenter {
    
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.flowLayout(type: .horizontalSmall)
        
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
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setWhiteNavigationBar(title: "Exchange")
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
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
