//
//  TransactionDetailsPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class TransactionDetailsPresenter {
    
    weak var view: TransactionDetailsViewInput!
    weak var output: TransactionDetailsModuleOutput?
    var interactor: TransactionDetailsInteractorInput!
    var router: TransactionDetailsRouterInput!
    
}


// MARK: - TransactionDetailsViewOutput

extension TransactionDetailsPresenter: TransactionDetailsViewOutput {

    func viewIsReady() {
        let transaction = interactor.getTransaction()
        configureNavigationBar(transaction: transaction)
        view.setupInitialState(transaction: transaction)
    }

}


// MARK: - TransactionDetailsInteractorOutput

extension TransactionDetailsPresenter: TransactionDetailsInteractorOutput {

}


// MARK: - TransactionDetailsModuleInput

extension TransactionDetailsPresenter: TransactionDetailsModuleInput {

    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
}


// MARK: - Private methods

extension TransactionDetailsPresenter {
    private func configureNavigationBar(transaction: TransactionDisplayable) {
        let title = transaction.direction == .receive ? "Deposit transaction" : "Send Transaction"
        view.viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        view.viewController.navigationItem.largeTitleDisplayMode = .never
        view.viewController.title = title
    }
}
