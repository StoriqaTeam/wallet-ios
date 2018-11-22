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
    func showRecepientAccountSelection(exchangeProviderBuilder: ExchangeProviderBuilderProtocol,
                                       from fromViewController: UIViewController) {
        RecepientAccountsModule.create(app: app,
                                       exchangeProviderBuilder: exchangeProviderBuilder).present(from: fromViewController)
    }
    
    func showConfirmSucceed(popUpDelegate: PopUpSendConfirmSuccessVMDelegate, from viewController: UIViewController) {
        let viewModel = PopUpSendConfirmSuccessVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showConfirmFailed(popUpDelegate: PopUpExchangeFailedVMDelegate,
                           message: String,
                           from viewController: UIViewController) {
        let viewModel = PopUpExchangeFailedVM(message: message)
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
}
