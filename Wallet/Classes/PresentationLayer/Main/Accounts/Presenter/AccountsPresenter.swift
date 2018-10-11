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
    
    private let accountDisplayer: AccountDisplayerProtocol
    private var accountsDataManager: AccountsDataManager!
    private var transactionDataManager: TransactionsDataManager!
    
    init(accountDisplayer: AccountDisplayerProtocol) {
        self.accountDisplayer = accountDisplayer
    }
}


// MARK: - AccountsViewOutput

extension AccountsPresenter: AccountsViewOutput {
    func viewAllPressed() {
        let transactions = interactor.getTransactionForCurrentAccount()
        router.showTransactions(from: view.viewController, transactions: transactions)
    }
    
    func configureCollections() {
        let index = interactor.getAccountIndex()
        accountsDataManager.scrollTo(index: index)
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
        let transations = interactor.getTransactionForCurrentAccount()
        let txDataManager = TransactionsDataManager(transactions: transations)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
        transactionDataManager.delegate = self
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
    
    func viewIsReady() {
        let numberOfPages = interactor.getAccountsCount()
        view.setupInitialState(numberOfPages: numberOfPages)
        configureNavBar()
    }
    
    func viewWillAppear() {
        view.viewController.setWhiteNavigationBarButtons()
    }
}


// MARK: - AccountsInteractorOutput

extension AccountsPresenter: AccountsInteractorOutput {
    
    func ISODidChange(_ iso: String) {
         view.viewController.setWhiteNavigationBar(title: "Account \(iso)")
    }
    
    func transactionsDidChange(_ txs: [TransactionDisplayable]) {
        transactionDataManager.updateTransactions(txs)
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
    func didChooseTransaction(_ transaction: TransactionDisplayable) {
        router.showTransactionDetails(with: transaction, from: view.viewController)
    }
}


// MARK: - Private methods

extension AccountsPresenter {
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
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        let iso = interactor.getInitialCurrencyISO()
        view.viewController.setWhiteNavigationBar(title: "Account \(iso)")
    }
}
