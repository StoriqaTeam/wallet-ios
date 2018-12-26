//
//  MyWalletRouter.swift
//  wallet-ios
//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import Foundation


class MyWalletRouter {
    
    private let app: Application
    
    init(app: Application) {
        self.app = app
    }
}


// MARK: - MyWalletRouterInput

extension MyWalletRouter: MyWalletRouterInput {
    func showAccountsWith(accountWatcher: CurrentAccountWatcherProtocol,
                          from fromViewController: UIViewController) {
        let accountsPresenter = AccountsModule.create(app: app,
                                                      accountWatcher: accountWatcher,
                                                      animator: nil)
        accountsPresenter.present(from: fromViewController)
    }
    
    func showAccountsWith(accountWatcher: CurrentAccountWatcherProtocol,
                          from fromViewController: UIViewController,
                          animator: MyWalletToAccountsAnimator) {
        if let customNavigation = fromViewController.navigationController as? TransitionNavigationController {
            customNavigation.setAnimator(animator: animator)
        }
        
        let accountsPresenter = AccountsModule.create(app: app,
                                                      accountWatcher: accountWatcher,
                                                      animator: animator)
        accountsPresenter.present(from: fromViewController)
    }
    
}
