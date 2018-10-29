//
//  Created by Storiqa on 21/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AccountsModule {
    
    class func create(app: Application,
                      accountWatcher: CurrentAccountWatcherProtocol,
                      tabBar: UITabBarController,
                      user: User) -> AccountsModuleInput {
        
        let router = AccountsRouter(app: app)
        
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: app.currencyFormatter,
                                                converterFactory: app.currencyConverterFactory,
                                                accountTypeResolver: app.accountTypeResolver)
        
        let presenter = AccountsPresenter(accountDisplayer: accountDisplayer,
                                          transactionsMapper: app.transactionMapper)
        presenter.mainTabBar = tabBar
        let interactor = AccountsInteractor(accountLinker: app.accountLinker,
                                            accountWatcher: accountWatcher,
                                            transactionsProvider: app.transactionsProvider)
    
        let accountsVC = UIStoryboard(name: "Accounts", bundle: nil)
        let viewController = accountsVC.instantiateViewController(withIdentifier: "accountsVC") as! AccountsViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        // MARK: - Channels
        let txsUpdateChannel = app.channelStorage.txsUpadteChannel
        app.transactionsProvider.setTxsUpdaterChannel(txsUpdateChannel)
        interactor.setTxsUpdateChannelInput(txsUpdateChannel)
        
        let accountsUpdateChannel = app.channelStorage.accountsUpadteChannel
        app.accountsProvider.setAccountsUpdaterChannel(accountsUpdateChannel)
        interactor.setAccountsUpdateChannelInput(accountsUpdateChannel)
        
        return presenter
    }
    
}
