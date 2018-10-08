//
//  MyWalletRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class MyWalletRouter {

}


// MARK: - MyWalletRouterInput

extension MyWalletRouter: MyWalletRouterInput {
    func showAccountsWith(accountWatcher: CurrentAccountWatcherProtocol,
                          from fromViewController: UIViewController,
                          tabBar: UITabBarController,
                          user: User) {
        
        
        let accountsPresenter = AccountsModule.create(accountWatcher: accountWatcher, tabBar: tabBar, user: user)
        accountsPresenter.present(from: fromViewController)
    }
}
