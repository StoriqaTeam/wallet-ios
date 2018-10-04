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
    
}


// MARK: - TransactionsViewOutput

extension TransactionsPresenter: TransactionsViewOutput {

    func transactionTableView(_ tableView: UITableView) {
        interactor.createTransactionsDataManager(with: tableView)
    }
    
    func viewIsReady() {
        view.setupInitialState()
        configureNavBar()
        interactor.setTransactionDataManagerDelegate(self)
    }

    func willMoveToParentVC() {
        view.viewController.setWhiteTextNavigationBar()
    }
    
    func viewWillAppear() {
        view.viewController.setDarkTextNavigationBar()
    }
    
    func didChooseSegment(at index: Int) {
        interactor.filterTransacitons(index: index)
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
    
}


// MARK: - Private methods

extension TransactionsPresenter {
    private func configureNavBar() {
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.title = "Transactions"
    }
}
