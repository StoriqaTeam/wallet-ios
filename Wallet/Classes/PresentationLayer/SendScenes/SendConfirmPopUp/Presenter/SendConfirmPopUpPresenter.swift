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
    private let total: String
    private let confirmTxBlock: (() -> Void)
    
    init(address: String, amount: String, fee: String, total: String, confirmTxBlock: @escaping (() -> Void)) {
        self.address = address
        self.amount = amount
        self.fee = fee
        self.total = total
        self.confirmTxBlock = confirmTxBlock
    }
}


// MARK: - SendConfirmPopUpViewOutput

extension SendConfirmPopUpPresenter: SendConfirmPopUpViewOutput {
    
    func viewIsReady() {
        let maskedAddress = address.maskCryptoAddress()
        view.setupInitialState(address: maskedAddress, amount: amount, fee: fee, total: total)
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
        let backBlur = captureScreen(view: AppDelegate.currentWindow)
        view.setBackgroundBlur(image: backBlur)
        
        view.viewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        view.presentModal(from: viewController)
    }
}
