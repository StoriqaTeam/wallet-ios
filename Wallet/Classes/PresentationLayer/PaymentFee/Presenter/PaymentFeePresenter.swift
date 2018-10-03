//
//  PaymentFeePresenter.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PaymentFeePresenter {
    
    weak var view: PaymentFeeViewInput!
    weak var output: PaymentFeeModuleOutput?
    var interactor: PaymentFeeInteractorInput!
    var router: PaymentFeeRouterInput!
    
}


// MARK: - PaymentFeeViewOutput

extension PaymentFeePresenter: PaymentFeeViewOutput {
    func newFeeSelected(_ index: Int) {
        interactor.setPaymentFee(index: index)
        
        let (fee, wait) = interactor.getFeeAndWait()
        view.setPaymentFee(fee)
        view.setMedianWait(wait)
        
        let subtotal = interactor.getSubtotal()
        view.setSubtotal(subtotal)
        
        let isEnoughFunds = interactor.isEnoughFunds()
        view.setErrorHidden(isEnoughFunds)
    }
    
    func sendButtonPressed() {
        let amount = interactor.getAmount()
        let address = interactor.getAddress()
        router.showConfirm(amount: amount,
                           address: address,
                           popUpDelegate: self,
                           from: view.viewController)
    }
    
    func editButtonPressed() {
        view.popToRoot()
    }

    func viewIsReady() {
        let apperance = interactor.getPaymentFeeScreenData()
        view.setupInitialState(apperance: apperance)
        view.viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func willMoveToParentVC() {
        view.viewController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

}


// MARK: - PaymentFeeInteractorOutput

extension PaymentFeePresenter: PaymentFeeInteractorOutput {

}


// MARK: - PaymentFeeModuleInput

extension PaymentFeePresenter: PaymentFeeModuleInput {
    
    func present(from viewController: UIViewController) {
        view.present(from: viewController)
    }
    
}


// MARK: - PopUpRegistrationSuccessVMDelegate

extension PaymentFeePresenter: PopUpSendConfirmVMDelegate {
    
    func confirmTransaction() {
        //TODO: send transaction
        let transaction = interactor.createTransaction()
    }
    
}



