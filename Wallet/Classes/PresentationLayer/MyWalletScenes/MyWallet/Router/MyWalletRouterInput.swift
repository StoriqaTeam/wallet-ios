//
//  MyWalletRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol MyWalletRouterInput: class {
    func showAccountsWith(accountWatcher: CurrentAccountWatcherProtocol,
                          from fromViewController: UIViewController)
    func showAccountsWith(accountWatcher: CurrentAccountWatcherProtocol,
                          from fromViewController: UIViewController,
                          animator: MyWalletToAccountsAnimator)
}
