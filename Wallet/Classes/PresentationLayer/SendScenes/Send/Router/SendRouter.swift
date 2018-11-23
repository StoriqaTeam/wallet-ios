//
//  SendRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SendRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - SendRouterInput

extension SendRouter: SendRouterInput {
    func showScanner(sendTransactionBuilder: SendProviderBuilderProtocol, from viewController: UIViewController) {
        QRScannerModule.create(app: app, sendTransactionBuilder: sendTransactionBuilder).present(from: viewController)
    }
    
    func showConfirm(address: String,
                     amount: String,
                     fee: String,
                     confirmTxBlock: @escaping (() -> Void),
                     from viewController: UIViewController) {
        SendConfirmPopUpModule
            .create(address: address, amount: amount, fee: fee, confirmTxBlock: confirmTxBlock)
            .present(from: viewController)
    }
    
    func showFailure(message: String,
                     from viewController: UIViewController) {
        let viewModel = PopUpDefaultFailureVM(message: message)
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
    
    func showConfirmSucceed(popUpDelegate: PopUpSendConfirmSuccessVMDelegate, from viewController: UIViewController) {
        let viewModel = PopUpSendConfirmSuccessVM()
        viewModel.delegate = popUpDelegate
        PopUpModule.create(viewModel: viewModel).present(from: viewController)
    }
}
