//
//  PaymentFeeRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class PaymentFeeRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }

}


// MARK: - PaymentFeeRouterInput

extension PaymentFeeRouter: PaymentFeeRouterInput {
    
    func showConfirm(amount: String,
                     address: String,
                     popUpDelegate: PopUpSendConfirmVMDelegate,
                     from viewController: UIViewController) {
        let viewModel = PopUpSendConfirmVM(amount: amount, address: address)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showConfirmFailed(message: String,
                           from viewController: UIViewController) {
        let viewModel = PopUpSendConfirmFailureVM(message: message)
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showConfirmSucceed(popUpDelegate: PopUpSendConfirmSuccessVMDelegate, from viewController: UIViewController) {
        let viewModel = PopUpSendConfirmSuccessVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
}
