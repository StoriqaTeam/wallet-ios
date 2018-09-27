//
//  SendRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class SendRouter {

}


// MARK: - SendRouterInput

extension SendRouter: SendRouterInput {
    func showReceiver(sendProvider: SendTransactionBuilderProtocol,
                      from viewController: UIViewController) {
        ReceiverModule.create(sendProvider: sendProvider).present(from: viewController)
    }
}
