//
//  MyWalletRouterInput.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


protocol MyWalletRouterInput: class {
    func showAccountsWith(selectedAccount: Account,
                          from fromViewController: UIViewController,
                          tabBar: UITabBarController)
}
