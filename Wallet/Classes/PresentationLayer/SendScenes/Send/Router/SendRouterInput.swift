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
    func showConfirm(address: String,
                     amount: String,
                     fee: String,
                     total: String,
                     confirmTxBlock: @escaping (() -> Void),
                     from viewController: UIViewController)
    func showFailure(message: String,
                     from viewController: UIViewController)
    func showConfirmSucceed(popUpDelegate: PopUpSendConfirmSuccessVMDelegate,
                            from viewController: UIViewController)
}
