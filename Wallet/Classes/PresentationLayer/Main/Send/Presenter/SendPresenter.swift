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
    
    private let currencyFormatter: CurrencyFormatterProtocol
    private let currencies = [
                               Currency.stq,
                               Currency.btc,
                               Currency.eth,
                               Currency.fiat ]
    
    init(currencyFormatter: CurrencyFormatterProtocol) {
        self.currencyFormatter = currencyFormatter
    }
}


// MARK: - SendViewOutput

extension SendPresenter: SendViewOutput {
    
    func nextButtonPressed() {
        let builder = interactor.getTransactionBuilder()
        router.showReceiver(sendTransactionBuilder: builder, from: view.viewController)
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
    
    func getAmountWithCurrency() -> String {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        return getStringfrom(amount: amount, currency: currency)
    }
    
    func getAmountWithoutCurrency() -> String {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        return getStringAmountWithoutCurrency(amount: amount, currency: currency)
    }
    
    func viewIsReady() {
        let currencyImages = currencies.map({ return $0.smallImage })
        let numberOfPages = interactor.getAccountsCount()
        configureNavBar()
        view.setButtonEnabled(false)
        view.setupInitialState(currencyImages: currencyImages, numberOfPages: numberOfPages)
        interactor.setAccountsDataManagerDelegate(self)
    }
    
}


// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {
    
    func updateAmount() {
        let amount = interactor.getAmount()
        let currency = interactor.getReceiverCurrency()
        let amountString = getStringfrom(amount: amount, currency: currency)
        view.updateAmount(amountString)
    }
    
    
    func updateAmount(_ amount: String) {
        view.updateAmount(amount)
    }
    
    func updateConvertedAmount(_ amount: String) {
        view.updateConvertedAmount(amount)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        interactor.createAccountsDataManager(with: collectionView)
    }
    
    func configureCollections() {
        interactor.scrollCollection()
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
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setWhiteTextNavigationBar()
        view.viewController.navigationController?.navigationBar.topItem?.title = "send".localized()
    }
    
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.accountsCollectionFlowLayout
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = deviceLayout.spacing
        flowLayout.itemSize = deviceLayout.size
        flowLayout.sectionInset = UIEdgeInsetsMake(0, deviceLayout.spacing * 2, 0, deviceLayout.spacing * 2)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    private func getStringfrom(amount: Decimal?, currency: Currency) -> String {
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
        
        return amount.description
    }
    
}
