//
//  TransactionsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsPresenter: NSObject {
    
    typealias LocalizedStrings = Strings.Transactions
    
    weak var view: TransactionsViewInput!
    weak var output: TransactionsModuleOutput?
    var interactor: TransactionsInteractorInput!
    var router: TransactionsRouterInput!
    
    private var transactionDataManager: TransactionsDataManager!
    private let transactionsDateFilter: TransactionDateFilterProtocol
    private let transactionsMapper: TransactionMapperProtocol
    
    private var transactions = [TransactionDisplayable]()
    private var transactionDirectionFilter = DirectionFilter.all
    
    init(transactionsDateFilter: TransactionDateFilterProtocol,
         transactionsMapper: TransactionMapperProtocol) {
        self.transactionsDateFilter = transactionsDateFilter
        self.transactionsMapper = transactionsMapper
    }
}


// MARK: - TransactionsViewOutput

extension TransactionsPresenter: TransactionsViewOutput {
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavBar()
        interactor.startObservers()
    }
    
    func transactionTableView(_ tableView: UITableView) {
        let transactions = interactor.getTransactions()
        let displayable = filteredDispayable(transactions)
        self.transactions = displayable
        let txDataManager = TransactionsDataManager(transactions: displayable, isHiddenSections: false)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
        transactionDataManager.delegate = self
        
        if transactions.isEmpty {
            transactionDataManager.updateEmpty(placeholderImage: UIImage(named: "noTxs")!,
                                               placeholderText: "")
        }
        
    }
    
    func viewWillAppear() {
        view.viewController.setDarkNavigationBarButtons()
        let transactions = interactor.getTransactions()
        let displayable = filteredDispayable(transactions)
        transactionDataManager.updateTransactions(displayable)
    }
    
    func didChooseSegment(at index: Int) {
        let filtered = getFilteredTransacitons(index: index)
        transactionDataManager.updateTransactions(filtered)
    }
    
    func filterByDateTapped() {
        router.showTransactionFilter(with: transactionsDateFilter, from: view.viewController)
    }
    
}


// MARK: - TransactionsInteractorOutput

extension TransactionsPresenter: TransactionsInteractorOutput {
    func updateTransactions(_ txs: [Transaction]) {
        let displayable = filteredDispayable(txs)
        self.transactions = displayable
        
        let directionFilteredTxs = filterTransactionsByDirection()
        transactionDataManager.updateTransactions(directionFilteredTxs)
    }
}


// MARK: - TransactionsModuleInput

extension TransactionsPresenter: TransactionsModuleInput {
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: TransactionsDataManagerdelegate

extension TransactionsPresenter: TransactionsDataManagerDelegate {
    func didChooseTransaction(_ transaction: TransactionDisplayable) {
        router.showTransactionDetails(with: transaction, from: view.viewController)
    }
}


// MARK: - Private methods

extension TransactionsPresenter {
    private func configureNavBar() {
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.setDarkNavigationBar(title: LocalizedStrings.navigationBarTitle)
    }
    
    func filteredDispayable(_ txs: [Transaction]) -> [TransactionDisplayable] {
        let account = interactor.getAccount()
        let displayable = txs.map { transactionsMapper.map(from: $0, account: account) }
        let dateFilteredTransactions = transactionsDateFilter.applyFilter(for: displayable)
        return dateFilteredTransactions
    }
    
    func getFilteredTransacitons(index: Int) -> [TransactionDisplayable] {
        guard let filter = DirectionFilter(rawValue: index) else { return [] }
        transactionDirectionFilter = filter
        
        let filteredTransactions = filterTransactionsByDirection()
        return filteredTransactions
    }
    
    private func filterTransactionsByDirection() -> [TransactionDisplayable] {
        let directionFilteredTxs = transactionsDateFilter.applyFilter(for: transactions)
        switch transactionDirectionFilter {
        case .all:
            return directionFilteredTxs
        case .send:
            return directionFilteredTxs.filter { $0.direction == .send }
        case .receive:
            return directionFilteredTxs.filter { $0.direction == .receive }
        }
    }
}
