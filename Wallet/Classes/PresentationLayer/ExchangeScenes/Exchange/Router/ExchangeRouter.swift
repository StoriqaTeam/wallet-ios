//
//  ExchangeRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ExchangeRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
    
}


// MARK: - ExchangeRouterInput

extension ExchangeRouter: ExchangeRouterInput {
    
    func showConfirmSucceed(popUpDelegate: PopUpSendConfirmSuccessVMDelegate, from viewController: UIViewController) {
        let viewModel = PopUpSendConfirmSuccessVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showConfirm(fromAccount: String,
                     toAccount: String,
                     fromAmount: String,
                     toAmount: String,
                     confirmTxBlock: @escaping (() -> Void),
                     from viewController: UIViewController) {
        ExchangeConfirmPopUpModule
            .create(fromAccount: fromAccount,
                    toAccount: toAccount,
                    fromAmount: fromAmount,
                    toAmount: toAmount,
                    confirmTxBlock: confirmTxBlock)
            .present(from: viewController)
    }
    
    func showConfirmFailed(popUpDelegate: PopUpExchangeFailedVMDelegate,
                           message: String,
                           from viewController: UIViewController) {
        let viewModel = PopUpExchangeFailedVM(message: message)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
}
