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
    func showAccountsWith(selectedAccount: Account,
                          from fromViewController: UIViewController,
                          tabBar: UITabBarController) {
        
        let accountsPresenter = AccountsModule.create(account: selectedAccount, tabBar: tabBar)
        accountsPresenter.present(from: fromViewController)
    }
}
