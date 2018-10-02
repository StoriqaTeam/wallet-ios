//
//  AccountsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AccountsPresenter {
    
    weak var view: AccountsViewInput!
    weak var output: AccountsModuleOutput?
    var interactor: AccountsInteractorInput!
    var router: AccountsRouterInput!
    weak var mainTabBar: UITabBarController!
    
}


// MARK: - AccountsViewOutput

extension AccountsPresenter: AccountsViewOutput {
    func viewAllPressed() {
        let transactions = interactor.getTransactionForCurrentAccount()
        router.showTransactions(from: view.viewController, transactions: transactions)
    }
    
    func configureCollections() {
        interactor.scrollCollection()
    }
    
    func handleCustomButton(type: RouteButtonType) {
        switch type {
        case .change:
            mainTabBar.selectedIndex = 2
        case .deposit:
            mainTabBar.selectedIndex = 3
        case .send:
            mainTabBar.selectedIndex = 1
        }
    }
    
    func transactionTableView(_ tableView: UITableView) {
        interactor.createTransactionsDataManager(with: tableView)
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = collectionFlowLayout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = true
        interactor.createAccountsDataManager(with: collectionView)
    }
    
    func viewIsReady() {
        let numberOfPages = interactor.getAccountsCount()
        view.setupInitialState(numberOfPages: numberOfPages)
        configureNavBar()
        interactor.setAccountsDataManagerDelegate(self)
        interactor.setTransactionDataManagerDelegate(self)
    }
}


// MARK: - AccountsInteractorOutput

extension AccountsPresenter: AccountsInteractorOutput {
    func ISODidChange(_ iso: String) {
         view.viewController.title = "Account \(iso)"
    }
}


// MARK: - AccountsModuleInput

extension AccountsPresenter: AccountsModuleInput {
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - AccountsDataManagerDelegate

extension AccountsPresenter: AccountsDataManagerDelegate {
    func currentPageDidChange(_ newIndex: Int) {
        interactor.setCurrentAccountWith(index: newIndex)
        view.setNewPage(newIndex)
    }
}


// MARK: - TransactionsDatamanagerDelegate

extension AccountsPresenter: TransactionsDataManagerDelegate {
    
}


// MARK: - Private methods

extension AccountsPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.accountsCollectionFlowLayout
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = deviceLayout.spacing
        flowLayout.itemSize = deviceLayout.size
        flowLayout.sectionInset = UIEdgeInsetsMake(0, deviceLayout.spacing * 2, 0, deviceLayout.spacing * 2)
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }
    
    private func configureNavBar() {
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.navigationController?.navigationBar.isTranslucent = true
        view.viewController.setWhiteTextNavigationBar()
        let iso = interactor.getInitialCurrencyISO()
        view.viewController.title = "Account \(iso)"
    }
    
    private func configureTransactionsTableView() {
        
    }
}
