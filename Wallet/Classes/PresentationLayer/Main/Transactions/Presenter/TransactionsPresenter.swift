//
//  TransactionsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 27/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionsPresenter: NSObject {
    
    weak var view: TransactionsViewInput!
    weak var output: TransactionsModuleOutput?
    var interactor: TransactionsInteractorInput!
    var router: TransactionsRouterInput!
    
    private var transactionDataManager: TransactionsDataManager!
}


// MARK: - TransactionsViewOutput

extension TransactionsPresenter: TransactionsViewOutput {

    func transactionTableView(_ tableView: UITableView) {
        let transactions = interactor.getTransactions()
        let txDataManager = TransactionsDataManager(transactions: transactions)
        txDataManager.setTableView(tableView)
        transactionDataManager = txDataManager
        transactionDataManager.delegate = self
        
        if transactions.isEmpty {
            transactionDataManager.updateEmpty(placeholderImage: UIImage(named: "noTxs")!,
                                               placeholderText: "")
        }
        
    }
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavBar()
    }

    func willMoveToParentVC() {
        view.viewController.setWhiteTextNavigationBar()
    }
    
    func viewWillAppear() {
        view.viewController.setDarkTextNavigationBar()
    }
    
    func didChooseSegment(at index: Int) {
        let filtered = interactor.getFilteredTransacitons(index: index)
        transactionDataManager.updateTransactions(filtered)
    }
    
}


// MARK: - TransactionsInteractorOutput

extension TransactionsPresenter: TransactionsInteractorOutput {

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
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.title = "Transactions"
    }
}
