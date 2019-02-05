//
//  ExchangePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangePresenter {
    
    typealias LocalizedStrings = Strings.Exchange
    
    weak var view: ExchangeViewInput!
    weak var output: ExchangeModuleOutput?
    var interactor: ExchangeInteractorInput!
    var router: ExchangeRouterInput!
    
    private let converterFactory: CurrencyConverterFactoryProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let accountDisplayer: AccountDisplayerProtocol
    private var fromAccountsDataManager: AccountsDataManager!
    private var toAccountsDataManager: AccountsDataManager!
    private let haptic: HapticServiceProtocol
    
    private var storiqaLoader: StoriqaLoader!
    private var isEditingFromAmount = false
    private var isEditingToAmount = false
    private var isRatesError = false
    
    init(converterFactory: CurrencyConverterFactoryProtocol,
         currencyFormatter: CurrencyFormatterProtocol,
         accountDisplayer: AccountDisplayerProtocol,
         haptic: HapticServiceProtocol) {
        
        self.converterFactory = converterFactory
        self.currencyFormatter = currencyFormatter
        self.accountDisplayer = accountDisplayer
        self.haptic = haptic
    }
}


// MARK: - ExchangeViewOutput

extension ExchangePresenter: ExchangeViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavBar()
        addLoader()
        
        interactor.startObservers()
    }
    
    func viewWillAppear() {
        interactor.updateState()
    }
    
    func fromAccountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView, cellType: .thin)
        fromAccountsDataManager = accountsManager
        fromAccountsDataManager.delegate = self
    }
    
    func toAccountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        
        let allAccounts = interactor.getRecipientAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView, cellType: .thin)
        toAccountsDataManager = accountsManager
        toAccountsDataManager.delegate = self
    }
    
    func configureCollections() {
        let index = interactor.getAccountIndex()
        fromAccountsDataManager.scrollTo(index: index)
    }
    
    func isValidAmount(_ amount: String) -> Bool {
        return amount.isEmpty || amount == "." || amount == "," || amount.isValidDecimal()
    }
    
    func fromAmountChanged(_ amount: String) {
        interactor.setFromAmount(amount.decimalValue())
    }
    
    func toAmountChanged(_ amount: String) {
        interactor.setToAmount(amount.decimalValue())
    }
    
    func fromAmountDidBeginEditing() {
        isEditingFromAmount = true
        let amount = interactor.getFromAmount()
        let currency = interactor.getFromCurrency()
        let formatted = getStringAmountWithoutCurrency(amount: amount, currency: currency)
        view.setFromAmount(formatted)
    }
    
    func fromAmountDidEndEditing() {
        isEditingFromAmount = false
        let amount = interactor.getFromAmount()
        let currency = interactor.getFromCurrency()
        let formatted = getStringFrom(amount: amount, currency: currency)
        view.setFromAmount(formatted)
    }
    
    func toAmountDidBeginEditing() {
        isEditingToAmount = true
        let amount = interactor.getToAmount()
        let currency = interactor.getToCurrency()
        let formatted = getStringAmountWithoutCurrency(amount: amount, currency: currency)
        view.setToAmount(formatted)
    }
    
    func toAmountDidEndEditing() {
        isEditingToAmount = false
        let amount = interactor.getToAmount()
        let currency = interactor.getToCurrency()
        let formatted = getStringFrom(amount: amount, currency: currency)
        view.setToAmount(formatted)
    }
    
    func exchangeButtonPressed() {
        let fromAccount = interactor.getFromAccountName()
        let toAccount = interactor.getToAccountName()
        let fromCurrency = interactor.getFromCurrency()
        let decimalFromAmount = interactor.getFromAmount()
        let fromAmountStr = currencyFormatter.getStringFrom(amount: decimalFromAmount, currency: fromCurrency)
        let toCurrency = interactor.getToCurrency()
        let decimalToAmount = interactor.getToAmount()
        let toAmountStr = currencyFormatter.getStringFrom(amount: decimalToAmount, currency: toCurrency)
        
        let confirmTxBlock = { [weak self] in
            self?.storiqaLoader.startLoader()
            self?.interactor.sendTransaction()
        }

        router.showConfirm(fromAccount: fromAccount,
                           toAccount: toAccount,
                           fromAmount: fromAmountStr,
                           toAmount: toAmountStr,
                           confirmTxBlock: confirmTxBlock,
                           from: view.viewController)
    }
    
}


// MARK: - ExchangeInteractorOutput

extension ExchangePresenter: ExchangeInteractorOutput {
    
    func updateOrder(time: Int?) {
        guard !isRatesError, let elapsedTime = time else {
            view.updateExpiredTimeLabel("")
            return
        }
        
        let elapsedString = timeFormatted(elapsedTime)
        view.updateExpiredTimeLabel(elapsedString)
    }
    
    func updateEmptyRate() {
        view.updateRateLabel(text: "")
    }
    
    func updateRateFor(oneUnit: Decimal, fromCurrency: Currency, toCurrency: Currency) {
        isRatesError = false
        
        let fromStr = currencyFormatter.getStringFrom(amount: 1, currency: fromCurrency)
        let rateStr = currencyFormatter.getStringFrom(amount: oneUnit, currency: toCurrency)
        
        let outString = "\(fromStr) = \(rateStr)"
        view.updateRateLabel(text: outString)
    }
    
    func updateFromAccounts(_ accounts: [Account], index: Int) {
        fromAccountsDataManager?.updateAccounts(accounts)
        fromAccountsDataManager?.scrollTo(index: index)
    }
    
    func updateToAccounts(_ accounts: [Account], index: Int) {
        toAccountsDataManager?.updateAccountsAnimated(accounts) {[weak self] in
            self?.toAccountsDataManager?.scrollTo(index: index)
        }
    }
    
    func exchangeRateError(_ error: Error) {
        isRatesError = true
        view.showExchangeRateError(message: error.localizedDescription)
    }
    
    func updateFromAmount(_ amount: Decimal, currency: Currency) {
        let amountString: String = {
            if isEditingFromAmount {
                return getStringAmountWithoutCurrency(amount: amount, currency: currency)
            } else {
                return getStringFrom(amount: amount, currency: currency)
            }
        }()
        view.setFromAmount(amountString)
        
        let placeholder = String(format: LocalizedStrings.amountPlaceholder, currency.ISO)
        view.updateFromPlaceholder(placeholder)
    }
    
    func updateToAmount(_ amount: Decimal, currency: Currency) {
        let amountString: String = {
            if isEditingToAmount {
                return getStringAmountWithoutCurrency(amount: amount, currency: currency)
            } else {
                return getStringFrom(amount: amount, currency: currency)
            }
        }()
        view.setToAmount(amountString)
        
        let placeholder = String(format: LocalizedStrings.amountPlaceholder, currency.ISO)
        view.updateToPlaceholder(placeholder)
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
        let message = String(format: LocalizedStrings.amountOutOfBounds, minAmountStr, maxAmountStr)
        
        router.showConfirmFailed(popUpDelegate: self, message: message, from: view.viewController)
    }
    
    func exceededDayLimit(limit: String, currency: Currency) {
        storiqaLoader.stopLoader()
        
        let limitStr = currencyFormatter.getStringFrom(amount: limit.decimalValue(), currency: currency)
        let message = String(format: LocalizedStrings.exceedDayLimitMessage, limitStr)
        
        router.showConfirmFailed(popUpDelegate: self, message: message, from: view.viewController)
    }
    
    func exchangeTxFailed(message: String) {
        storiqaLoader.stopLoader()
        haptic.performNotificationHaptic(feedbackType: .error)
        router.showConfirmFailed(popUpDelegate: self, message: message, from: view.viewController)
    }
    
    func exchangeTxSucceed() {
        storiqaLoader.stopLoader()
        haptic.performNotificationHaptic(feedbackType: .success)
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
    
    func currentPageDidChange(_ newIndex: Int, manager: AccountsDataManager) {
        switch manager {
        case fromAccountsDataManager:
            interactor.setFromAccount(index: newIndex)
        case toAccountsDataManager:
            interactor.setToAccount(index: newIndex)
        default: break
        }
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
        let deviceLayout = Device.model.flowLayout(type: .horizontalThin)
        return deviceLayout
    }
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setHidableNavigationBar(title: LocalizedStrings.navigationBarTitle)
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
