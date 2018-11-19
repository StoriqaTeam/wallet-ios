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
    
    func newFeeSelected(_ index: Int) {
        interactor.setPaymentFee(index: index)
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
        //TODO: exchangeButtonPressed
    }
    
}


// MARK: - ExchangeInteractorOutput

extension ExchangePresenter: ExchangeInteractorOutput {
    
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
            view.setPaymentFee("-")
            return
        }
        
        let currency = interactor.getAccountCurrency()
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
        let totalAmountString = currencyFormatter.getStringFrom(amount: total, currency: currency)
        view.setSubtotal(totalAmountString)
    }
    
    func updateIsEnoughFunds(_ enough: Bool) {
        view.setErrorHidden(enough)
    }
    
    func updateFormIsValid(_ valid: Bool) {
        view.setButtonEnabled(valid)
    }
    
    func exchangeTxFailed(message: String) {
        // TODO: exchangeTxFailed
        print("exchangeTxFailed")
    }
    
    func exchangeTxSucceed() {
        // TODO: exchangeTxSucceed
        print("exchangeTxSucceed")
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
}
