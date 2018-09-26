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
    func showPaymentFee(sendProvider: SendTransactionBuilderProtocol,
                        from viewController: UIViewController) {
        PaymentFeeModule.create(sendProvider: sendProvider).present(from: viewController)
    }
    
    func showScanner(sendProvider: SendTransactionBuilderProtocol,
                     from viewController: UIViewController) {
        QRScannerModule.create(sendProvider: sendProvider).present(from: viewController)
    }
    
}
