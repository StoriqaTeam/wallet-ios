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
    private let currencies = [
        Currency.stq,
        Currency.btc,
        Currency.eth,
        Currency.fiat ]
    
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
    
    func nextButtonPressed() {
        let builder = interactor.getTransactionBuilder()
        router.showReceiver(sendTransactionBuilder: builder,
                            from: view.viewController,
                            mainTabBar: mainTabBar)
    }
    
    func receiverCurrencyChanged(_ index: Int) {
        interactor.setReceiverCurrency(currencies[index])
    }
    
    func isValidAmount(_ amount: String) -> Bool {
        return interactor.isValidAmount(amount)
    }
    
    func amountChanged(_ amount: String) {
        interactor.setAmount(amount)
        
        let formIsValid = interactor.isFormValid()
        view.setButtonEnabled(formIsValid)
    }
    
    func amountDidBeginEditing() {
        let amount = interactor.getAmount()
        let formatted = getStringAmountWithoutCurrency(amount: amount)
        view.setAmount(formatted)
    }
    
    func amountDidEndEditing() {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        let formatted = getStringFrom(amount: amount, currency: currency)
        view.setAmount(formatted)
    }
    
    func viewIsReady() {
        let currencyImages = currencies.map({
            return currencyImageProvider.smallImage(for: $0)
        })
        let numberOfPages = interactor.getAccountsCount()
        configureNavBar()
        view.setButtonEnabled(false)
        view.setupInitialState(currencyImages: currencyImages, numberOfPages: numberOfPages)
        interactor.startObservers()
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
    
    func viewWillAppear() {
        view.viewController.setWhiteNavigationBarButtons()
        
        interactor.updateTransactionProvider()
        
        let selectedReceiverCurrency = interactor.getReceiverCurrency()
        let receiverCurrencyIndex = currencies.firstIndex(of: selectedReceiverCurrency)!
        let formIsValid = interactor.isFormValid()
        
        updateAmount()
        updateConvertedAmount()
        view.setReceiverCurrencyIndex(receiverCurrencyIndex)
        view.setButtonEnabled(formIsValid)
    }
    
}


// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {
    func updateAmount() {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        let amountString = getStringFrom(amount: amount, currency: currency)
        view.setAmount(amountString)
    }
    
    func updateConvertedAmount() {
        let amount = interactor.getConvertedAmount()
        
        if amount.isZero {
            view.setConvertedAmount("")
        } else {
            let currency = interactor.getSelectedAccountCurrency()
            let amountString = "≈" + getStringFrom(amount: amount, currency: currency)
            view.setConvertedAmount(amountString)
        }
    }
    
    func updateAccounts(accounts: [Account], index: Int) {
        accountsDataManager?.updateAccounts(accounts)
        accountsDataManager?.scrollTo(index: index)
        view.updatePagesCount(accounts.count)
        view.setNewPage(index)
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

// MARK: - AccountsDataManagerDelegate

extension SendPresenter: AccountsDataManagerDelegate {
    func currentPageDidChange(_ newIndex: Int) {
        interactor.setCurrentAccountWith(index: newIndex)
        view.setNewPage(newIndex)
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
    
    private func getStringAmountWithoutCurrency(amount: Decimal?) -> String {
        guard let amount = amount, !amount.isZero else {
            return ""
        }
        
        return amount.string
    }
    
}
