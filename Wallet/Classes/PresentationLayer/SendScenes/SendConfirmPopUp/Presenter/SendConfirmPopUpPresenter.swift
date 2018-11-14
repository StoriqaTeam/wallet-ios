//
//  SendConfirmPopUpPresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 14/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendConfirmPopUpPresenter {
    
    weak var view: SendConfirmPopUpViewInput!
    weak var output: SendConfirmPopUpModuleOutput?
    var interactor: SendConfirmPopUpInteractorInput!
    var router: SendConfirmPopUpRouterInput!
    
    private let address: String
    private let amount: String
    private let fee: String
    private let confirmTxBlock: (() -> Void)
    
    init(address: String, amount: String, fee: String, confirmTxBlock: @escaping (() -> Void)) {
        self.address = address
        self.amount = amount
        self.fee = fee
        self.confirmTxBlock = confirmTxBlock
    }
}


// MARK: - SendConfirmPopUpViewOutput

extension SendConfirmPopUpPresenter: SendConfirmPopUpViewOutput {
    
    func viewIsReady() {
        view.setupInitialState(address: address, amount: amount, fee: fee)
    }
    
    func confirmButtonTapped() {
        confirmTxBlock()
    }

}


// MARK: - SendConfirmPopUpInteractorOutput

extension SendConfirmPopUpPresenter: SendConfirmPopUpInteractorOutput {

}


// MARK: - SendConfirmPopUpModuleInput

extension SendConfirmPopUpPresenter: SendConfirmPopUpModuleInput {

    func present(from viewController: UIViewController) {
        view.viewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        view.presentModal(from: viewController)
    }
}
