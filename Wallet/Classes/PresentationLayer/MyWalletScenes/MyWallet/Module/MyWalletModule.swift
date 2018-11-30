//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MyWalletModule {
    
    class func create(app: Application,
                      tabBar: UITabBarController,
                      accountWatcher: CurrentAccountWatcherProtocol) -> MyWalletModuleInput {
        let router = MyWalletRouter(app: app)
        
        let presenter = MyWalletPresenter(accountDisplayer: app.accountDisplayer,
                                          denominationUnitsConverter: app.denominationUnitsConverter,
                                          currencyFormatter: app.currencyFormatter)
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
        
        let userUpadteChannel = app.channelStorage.userUpdateChannel
        interactor.setUserUpdateChannelInput(userUpadteChannel)
        
        let receivedTxsChannel = app.channelStorage.receivedTxsChannel
        app.receivedTransactionProvider.setReceivedTxsChannel(receivedTxsChannel)
        interactor.setReceivedTxsChannelInput(receivedTxsChannel)
        
        return presenter
    }
    
}
