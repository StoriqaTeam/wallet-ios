//
//  ExchangeRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol ExchangeRouterInput: class {
    func showRecipientAccountSelection(exchangeProviderBuilder: ExchangeProviderBuilderProtocol,
                                       from fromViewController: UIViewController)
    func showConfirm(fromAccount: String,
                     toAccount: String,
                     amount: String,
                     confirmTxBlock: @escaping (() -> Void),
                     from viewController: UIViewController)
    func showConfirmSucceed(popUpDelegate: PopUpSendConfirmSuccessVMDelegate,
                            from viewController: UIViewController)
    func showConfirmFailed(popUpDelegate: PopUpExchangeFailedVMDelegate,
                           message: String,
                           from viewController: UIViewController)
}
