//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendModule {
    
    class func create(app: Application,
                      accountWatcher: CurrentAccountWatcherProtocol,
                      tabBar: UITabBarController) -> SendModuleInput {
        let router = SendRouter(app: app)
        let presenter = SendPresenter(currencyFormatter: app.currencyFormatter,
                                      currencyImageProvider: app.currencyImageProvider,
                                      accountDisplayer: app.accountDisplayer)
        presenter.mainTabBar = tabBar
        
        let sendTransactionBuilder = app.sendTransactionBuilderFactory.create()
        let interactor = SendInteractor(sendTransactionBuilder: sendTransactionBuilder,
                                        accountsProvider: app.accountsProvider,
                                        accountWatcher: accountWatcher,
                                        cryptoAddressResolver: app.cryptoAddressResolver,
                                        sendTransactionService: app.sendTransactionService,
                                        feeLoader: app.feeLoader)
        
        let sendSb = UIStoryboard(name: "Send", bundle: nil)
        let viewController = sendSb.instantiateViewController(withIdentifier: "sendVC") as! SendViewController
        
        interactor.output = presenter
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        // MARK: - Channels
        let accountsUpdateChannel = app.channelStorage.accountsUpadteChannel
        app.accountsProvider.setAccountsUpdaterChannel(accountsUpdateChannel)
        interactor.setAccountsUpdateChannelInput(accountsUpdateChannel)
        
        return presenter
    }
    
}
