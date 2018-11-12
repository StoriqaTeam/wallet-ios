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
    private let transactionsMapper: TransactionMapperProtocol
    private var accountsDataManager: AccountsDataManager!
    private var transactionDataManager: TransactionsDataManager!
    
    init(accountDisplayer: AccountDisplayerProtocol,
         transactionsMapper: TransactionMapperProtocol) {
        self.accountDisplayer = accountDisplayer
        self.transactionsMapper = transactionsMapper
    }
}


// MARK: - AccountsViewOutput

extension AccountsPresenter: AccountsViewOutput {
    func viewAllPressed() {
        let account = interactor.getSelectedAccount()
        router.showTransactions(from: view.viewController, account: account)
    }
    
    func configureCollections() {
        let index = interactor.getAccountIndex()
        accountsDataManager.scrollTo(index: index)
    }
    
    func handleCustomButton(type: RouteButtonType) {
        switch type {
        case .change:
            // FIXME: exchange hidden before release
//            mainTabBar.selectedIndex = 2
            view.viewController.showAlert(message: "Exchange module is not ready yet")
        case .deposit:
            // FIXME: exchange hidden before release
            mainTabBar.selectedIndex = 2 // 3
        case .send:
            mainTabBar.selectedIndex = 1
        }
    }
    
    func transactionTableView(_ tableView: UITableView) {
        let transactions = interactor.getTransactionForCurrentAccount()
        let account = interactor.getSelectedAccount()
        let displayable = transactions.map { transactionsMapper.map(from: $0, account: account) }
        let txDataManager = TransactionsDataManager(transactions: displayable, isHiddenSections: true, maxCount: 10)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
        transactionDataManager.delegate = self
        
        if displayable.isEmpty {
            transactionDataManager.updateEmpty(placeholderImage: UIImage(named: "noTxs")!,
                                               placeholderText: "")
        }
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
        interactor.startObservers()
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
    
    func transactionsDidChange(_ txs: [Transaction]) {
        let account = interactor.getSelectedAccount()
        let displayable = txs.map { transactionsMapper.map(from: $0, account: account) }
        transactionDataManager.updateTransactions(displayable)
    }
    
    func updateAccounts(accounts: [Account], index: Int) {
        accountsDataManager?.updateAccounts(accounts)
        accountsDataManager?.scrollTo(index: index)
        view.updatePagesCount(accounts.count)
        view.setNewPage(index)
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
