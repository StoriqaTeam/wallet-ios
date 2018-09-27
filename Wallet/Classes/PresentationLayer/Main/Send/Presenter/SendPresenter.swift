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
    
    private let currencies = [ Currency.stq,
                               Currency.btc,
                               Currency.eth,
                               Currency.fiat ]
}


// MARK: - SendViewOutput

extension SendPresenter: SendViewOutput {
    
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
        return interactor.getAmountWithCurrency()
    }
    
    func getAmountWithoutCurrency() -> String {
        return interactor.getAmountWithoutCurrency()
    }
    
    func viewIsReady() {
        let currencyImages = currencies.map({ return $0.image })
        configureNavBar()
        view.setButtonEnabled(false)
        view.setupInitialState(currencyImages: currencyImages)
        interactor.setAccountsDataManagerDelegate(self)
    }
    
}


// MARK: - SendInteractorOutput

extension SendPresenter: SendInteractorOutput {
    
    func updateAmount(_ amount: String) {
        view.updateAmount(amount)
    }
    
    func updateConvertedAmount(_ amount: String) {
        view.updateConvertedAmount(amount)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.isPagingEnabled = true
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
        view.viewController.setDarkTextNavigationBar()
        view.viewController.navigationController?.navigationBar.topItem?.title = "send".localized()
    }
    
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let spacing: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        if Device.isSmallScreen {
            width = 280
            height = 165
        } else {
            width = 336
            height = 198
        }
        spacing = (Constants.Sizes.screenWith - width) / 4
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.minimumLineSpacing = spacing
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, spacing * 2, 0, spacing * 2)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
}
