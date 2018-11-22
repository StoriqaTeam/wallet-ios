//
//  ExchangeConfirmPopUpPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeConfirmPopUpPresenter {
    
    weak var view: ExchangeConfirmPopUpViewInput!
    weak var output: ExchangeConfirmPopUpModuleOutput?
    var interactor: ExchangeConfirmPopUpInteractorInput!
    var router: ExchangeConfirmPopUpRouterInput!
    
    private let fromAccount: String
    private let toAccount: String
    private let amount: String
    private let confirmTxBlock: (() -> Void)
    
    init(fromAccount: String, toAccount: String, amount: String, confirmTxBlock: @escaping (() -> Void)) {
        self.fromAccount = fromAccount
        self.toAccount = toAccount
        self.amount = amount
        self.confirmTxBlock = confirmTxBlock
    }
    
}


// MARK: - ExchangeConfirmPopUpViewOutput

extension ExchangeConfirmPopUpPresenter: ExchangeConfirmPopUpViewOutput {
    
    func viewIsReady() {
        view.setupInitialState(fromAccount: fromAccount, toAccount: toAccount, amount: amount)
    }
    
    func confirmButtonTapped() {
        confirmTxBlock()
    }

}


// MARK: - ExchangeConfirmPopUpInteractorOutput

extension ExchangeConfirmPopUpPresenter: ExchangeConfirmPopUpInteractorOutput {

}


// MARK: - ExchangeConfirmPopUpModuleInput

extension ExchangeConfirmPopUpPresenter: ExchangeConfirmPopUpModuleInput {

    func present(from viewController: UIViewController) {
        view.viewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        view.presentModal(from: viewController)
    }
}
