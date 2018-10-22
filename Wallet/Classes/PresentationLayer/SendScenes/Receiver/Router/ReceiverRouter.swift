//
//  ReceiverRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class ReceiverRouter {
    
}


// MARK: - ReceiverRouterInput

extension ReceiverRouter: ReceiverRouterInput {
    func showPaymentFee(sendTransactionBuilder: SendProviderBuilderProtocol,
                        from viewController: UIViewController,
                        tabBar: UITabBarController) {
        PaymentFeeModule.create(sendTransactionBuilder: sendTransactionBuilder, tabBar: tabBar).present(from: viewController)
    }
    
    func showScanner(sendTransactionBuilder: SendProviderBuilderProtocol, from viewController: UIViewController) {
        QRScannerModule.create(sendTransactionBuilder: sendTransactionBuilder).present(from: viewController)
    }
}
