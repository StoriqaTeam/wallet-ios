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
    private var currencyConverter: CurrencyConverterProtocol!
    private let accountDisplayer: AccountDisplayerProtocol
    private var accountsTableDataManager: AccountsTableDataManager!
    private var accountsDataManager: AccountsDataManager!
    
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
        
        interactor.updateInitialState()
        interactor.startObservers()
    }
    
    func viewWillAppear() {
        view.viewController.setWhiteNavigationBarButtons()
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
    
    func accountsActionSheet(_ tableView: UITableView) {
        let currencyImageProvider = CurrencyImageProvider()
        let accountsManager = AccountsTableDataManager(currencyFormatter: currencyFormatter,
                                                       currencyImageProvider: currencyImageProvider)
        accountsManager.setTableView(tableView)
        accountsTableDataManager = accountsManager
        accountsTableDataManager.delegate = self
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
        let amount = interactor.getAmount()
        
        if amount.isZero {
            view.setAmount("")
        } else {
            view.setAmount(amount.description)
        }
    }
    
    func amountDidEndEditing() {
        let amount = interactor.getAmount()
        let currency = interactor.getRecepientCurrency()
        updateAmount(amount, currency: currency)
    }
    
    func newFeeSelected(_ index: Int) {
        interactor.setPaymentFee(index: index)
    }
    
    func recepientAccountPressed() {
        let accounts = interactor.getRecepientAccounts()
        
        guard !accounts.isEmpty else {
            return
        }
        
        accountsTableDataManager.accounts = accounts
        
        let height = accountsTableDataManager.calculateHeight()
        view.showAccountsActionSheet(height: height)
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
            return
        }
        
        currencyConverter = converterFactory.createConverter(from: account.currency)
        view.setRecepientAccount(account.name)
    }
    
    func updateAmount(_ amount: Decimal, currency: Currency) {
        guard !amount.isZero else {
            view.setAmount("")
            return
        }
        
        let formatted = currencyFormatter.getStringFrom(amount: amount, currency: currency)
        view.setAmount(formatted)
    }
    
    func convertAmount(_ amount: Decimal, to currency: Currency) {
        guard let currencyConverter = currencyConverter, !amount.isZero else {
            view.setConvertedAmount("")
            return
        }
        
        let converted = currencyConverter.convert(amount: amount, to: currency)
        let formatted = currencyFormatter.getStringFrom(amount: converted, currency: currency)
        view.setConvertedAmount("≈" + formatted)
    }
    
    func updatePaymentFee(_ fee: Decimal) {
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
    
    func updateTotal(_ total: Decimal, accountCurrency: Currency) {
        guard !total.isZero else {
            view.setSubtotal("")
            return
        }
        
        let formatted = currencyFormatter.getStringFrom(amount: total, currency: accountCurrency)
        view.setSubtotal(formatted)
    }
    
    func updateIsEnoughFunds(_ enough: Bool) {
        view.setErrorHidden(enough)
    }
    
    func updateFormIsValid(_ valid: Bool) {
        view.setButtonEnabled(valid)
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


// MARK: - AccountsTableDataManagerDelegate

extension ExchangePresenter: AccountsTableDataManagerDelegate {
    func chooseAccount(_ index: Int) {
        interactor.setRecepientAccount(index: index)
        view.hideAccountsActionSheet()
    }
}


// MARK: - Private methods

extension ExchangePresenter {
    
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.accountsCollectionSmallFlowLayout
        
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
}
