//
//  SendRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol SendRouterInput: class {
    func showScanner(sendTransactionBuilder: SendProviderBuilderProtocol,
                     from viewController: UIViewController)
    func showConfirm(amount: String,
                     address: String,
                     popUpDelegate: PopUpSendConfirmVMDelegate,
                     from viewController: UIViewController)
    func showConfirmFailed(message: String,
                           from viewController: UIViewController)
    func showConfirmSucceed(popUpDelegate: PopUpSendConfirmSuccessVMDelegate,
                            from viewController: UIViewController)
}
