//
//  ReceiverRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ReceiverRouterInput: class {
    func showScanner(sendTransactionBuilder: SendProviderBuilderProtocol,
                     from viewController: UIViewController)
    
    func showPaymentFee(sendTransactionBuilder: SendProviderBuilderProtocol,
                        from viewController: UIViewController,
                        tabBar: UITabBarController)
}
