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
    
    private let accountDisplayer: AccountDisplayerProtocol
    private let transactionsMapper: TransactionMapperProtocol
    private var accountsDataManager: AccountsDataManager!
    private var transactionDataManager: TransactionsDataManager!
    private var animator: MyWalletToAccountsAnimator?
    private var didAppear = false
    private let maxTxsCount = 10
    
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
        resetAnimatorIfNeeded()
        
        let account = interactor.getSelectedAccount()
        router.showTransactions(from: view.viewController, account: account)
    }
    
    func configureCollections() {
        let index = interactor.getAccountIndex()
        accountsDataManager.scrollTo(index: index)
    }
    
    func transactionTableView(_ tableView: UITableView) {
        let txDataManager = TransactionsDataManager(transactions: [], isHiddenSections: true)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
        transactionDataManager.delegate = self
    }
    
    func accountsCollectionView(_ collectionView: UICollectionView) {
        let collectionViewLayout = self.collectionFlowLayout
        collectionView.collectionViewLayout = collectionViewLayout
        
        let allAccounts = interactor.getAccounts()
        let accountsManager = AccountsDataManager(accounts: allAccounts,
                                                  accountDisplayer: accountDisplayer)
        accountsManager.setCollectionView(collectionView)
        accountsDataManager = accountsManager
        accountsDataManager.delegate = self
        
        let height = collectionViewLayout.itemSize.height + collectionViewLayout.minimumLineSpacing * 2
        view.setCollectionHeight(height)
        
        setupAnimatior()
    }
    
    func viewIsReady() {
        let numberOfPages = interactor.getAccountsCount()
        view.setupInitialState(numberOfPages: numberOfPages)
        configureNavBar()
        interactor.startObservers()
        animator?.delegate = self
    }
}


// MARK: - AccountsInteractorOutput

extension AccountsPresenter: AccountsInteractorOutput {
    
    func ISODidChange(_ iso: String) {
        if view.viewController.isViewLoaded && view.viewController.view?.window != nil {
            // viewController is visible
            // to prevent changing bar color on other controllers in stack
            view.viewController.title = "Account \(iso)"
        }
    }
    
    func transactionsDidChange(_ txs: [Transaction]) {
        guard didAppear else { return }
        view.setViewAllButtonHidden(txs.isEmpty)
        
        getDisplayable(from: txs, completion: { [weak self] (displayable) in
            self?.transactionDataManager.updateTransactions(displayable)
        })
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
    func viewDidBecomeVisible() {
        guard !didAppear else { return }
        didAppear = true
        
        let transactions = interactor.getTransactionForCurrentAccount()
        view.setViewAllButtonHidden(transactions.isEmpty)
        
        getDisplayable(from: transactions, completion: { [weak self] (displayable) in
            self?.transactionDataManager.firstUpdateTransactions(displayable)
        })
    }
    
    func animationComplete(completion: @escaping (() -> Void)) {
        view.showAccounts(completion: completion)
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
        resetAnimatorIfNeeded()
        router.showTransactionDetails(with: transaction, from: view.viewController)
    }
}


// MARK: - Private methods

extension AccountsPresenter {
    private var collectionFlowLayout: UICollectionViewFlowLayout {
        let deviceLayout = Device.model.flowLayout(type: .horizontal)
        return deviceLayout
    }
    
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        let iso = interactor.getInitialCurrencyISO()
        view.viewController.title = "Account \(iso)"
    }
    
    private func setupAnimatior() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let navigationBarHeight = view.viewController.navigationController?.navigationBar.frame.height ?? 44
        let itemX = (Constants.Sizes.screenWidth - collectionFlowLayout.itemSize.width) / 2
        let itemY = statusBarHeight + navigationBarHeight + collectionFlowLayout.minimumLineSpacing
        let newFrame = CGRect(x: itemX,
                              y: itemY,
                              width: collectionFlowLayout.itemSize.width,
                              height: collectionFlowLayout.itemSize.height)
        
        animator?.setDestinationFrame(newFrame)
    }
    
    private func resetAnimatorIfNeeded() {
        if let navigation = view.viewController.navigationController as? TransitionNavigationController {
            navigation.useDefaultTransitioningDelegate()
        }
    }
    
    private func getDisplayable(from txs: [Transaction], completion: @escaping ([TransactionDisplayable]) -> Void) {
        let txs = txs.sorted { $0.createdAt > $1.createdAt }
        let lastTxs = Array(txs.prefix(maxTxsCount))
        let account = interactor.getSelectedAccount()
        transactionsMapper.map(from: lastTxs, account: account) { (displayable) in
            completion(displayable)
        }
    }
}
