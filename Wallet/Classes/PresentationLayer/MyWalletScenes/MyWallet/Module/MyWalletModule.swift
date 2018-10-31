//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MyWalletModule {
    
    class func create(app: Application,
                      tabBar: UITabBarController,
                      accountWatcher: CurrentAccountWatcherProtocol,
                      user: User) -> MyWalletModuleInput {
        let router = MyWalletRouter(app: app)
        
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: app.currencyFormatter,
                                                converterFactory: app.currencyConverterFactory,
                                                accountTypeResolver: app.accountTypeResolver,
                                                denominationUnitsConverter: app.denominationUnitsConverter)
        
        let presenter = MyWalletPresenter(user: user, accountDisplayer: accountDisplayer)
        presenter.mainTabBar = tabBar
        
        let interactor = MyWalletInteractor(accountsProvider: app.accountsProvider,
                                            accountWatcher: accountWatcher,
                                            accountsUpdater: app.accountsUpdater,
                                            txnUpdater: app.transactionsUpdater)
        
        let myWalletSb = UIStoryboard(name: "MyWallet", bundle: nil)
        let viewController = myWalletSb.instantiateViewController(withIdentifier: "myWalletVC") as! MyWalletViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        // MARK: - Channels
        let accountsUpadteChannel = app.channelStorage.accountsUpadteChannel
        app.accountsProvider.setAccountsUpdaterChannel(accountsUpadteChannel)
        interactor.setAccountsUpdateChannelInput(accountsUpadteChannel)
        
        return presenter
    }
    
}
