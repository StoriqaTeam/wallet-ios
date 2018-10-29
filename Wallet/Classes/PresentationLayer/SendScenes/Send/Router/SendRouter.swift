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
    func showReceiver(sendTransactionBuilder: SendProviderBuilderProtocol,
                      from viewController: UIViewController,
                      mainTabBar: UITabBarController) {
        
        ReceiverModule.create(app: app,
                              sendTransactionBuilder: sendTransactionBuilder,
                              tabBar: mainTabBar).present(from: viewController)
    }
}
