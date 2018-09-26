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
    }
    
    func sendButtonPressed() {
        //TODO: create transaction
    }
    
    func editButtonPressed() {
        //TODO: edit button action
    }

    func viewIsReady() {
        let apperance = interactor.getPaymentFeeScreenData()
        view.setupInitialState(apperance: apperance)
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
