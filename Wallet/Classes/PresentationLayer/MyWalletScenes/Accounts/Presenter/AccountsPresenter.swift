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
    private var animator: MyWalletToAccountsAnimator?
    
    init(accountDisplayer: AccountDisplayerProtocol,
         transactionsMapper: TransactionMapperProtocol,
         animator: MyWalletToAccountsAnimator?) {
        
        self.accountDisplayer = accountDisplayer
        self.transactionsMapper = transactionsMapper
        self.animator = animator
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
            mainTabBar.selectedIndex = 2
        case .deposit:
            mainTabBar.selectedIndex = 3
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
        animator?.delegate = self
    }
    
    func viewWillAppear() {
        view.viewController.setWhiteNavigationBarButtons()
    }
}


// MARK: - AccountsInteractorOutput

extension AccountsPresenter: AccountsInteractorOutput {
    
    func ISODidChange(_ iso: String) {
        if view.viewController.isViewLoaded && view.viewController.view?.window != nil {
            // viewController is visible
            // to prevent changing bar color on other controllers in stack
            view.viewController.setWhiteNavigationBar(title: "Account \(iso)")
        }
    }
    
    func transactionsDidChange(_ txs: [Transaction]) {
        let account = interactor.getSelectedAccount()
        
        transactionsMapper.map(from: txs, account: account) { [weak self] (displayable) in
            self?.transactionDataManager.updateTransactions(displayable)
        }
    }
    
    func updateAccounts(accounts: [Account], index: Int) {
        accountsDataManager?.updateAccounts(accounts)
        accountsDataManager?.scrollTo(index: index)
        view.updatePagesCount(accounts.count)
        view.setNewPage(index)
    }
    
    func userDidUpdate() {
        accountsDataManager?.reloadData()
    }
    
}


// MARK: - AccountsModuleInput

extension AccountsPresenter: AccountsModuleInput {
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - MyWalletToAccountsAnimatorDelegate

extension AccountsPresenter: MyWalletToAccountsAnimatorDelegate {
    func animationComplete() {
        view.showAccounts()
    }
}


// MARK: - AccountsDataManagerDelegate

extension AccountsPresenter: AccountsDataManagerDelegate {
    func rectOfChosenItem(_ rect: CGRect?, in collectionView: UICollectionView) {
        guard let frame = rect else { return }
        let accountFrame = collectionView.convert(frame, to: view.viewController.view)
        animator?.setDestinationFrame(accountFrame)
    }
    
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
        let deviceLayout = Device.model.flowLayout(type: .horizontal)
        
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
