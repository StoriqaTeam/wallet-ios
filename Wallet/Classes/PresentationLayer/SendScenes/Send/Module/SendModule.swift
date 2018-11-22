//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendModule {
    
    class func create(app: Application,
                      accountWatcher: CurrentAccountWatcherProtocol,
                      user: User,
                      tabBar: UITabBarController) -> SendModuleInput {
        let router = SendRouter(app: app)
        
        
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: app.currencyFormatter,
                                                converterFactory: app.currencyConverterFactory,
                                                accountTypeResolver: app.accountTypeResolver,
                                                denominationUnitsConverter: app.denominationUnitsConverter)
        let sendTransactionBuilder = app.sendTransactionBuilderFactory.create()
        
        
        let presenter = SendPresenter(currencyFormatter: app.currencyFormatter,
                                      currencyImageProvider: app.currencyImageProvider,
                                      accountDisplayer: accountDisplayer)
        presenter.mainTabBar = tabBar
        let interactor = SendInteractor(sendTransactionBuilder: sendTransactionBuilder,
                                        accountsProvider: app.accountsProvider,
                                        accountWatcher: accountWatcher,
                                        cryptoAddressResolver: app.cryptoAddressResolver,
                                        sendTransactionService: app.sendTransactionService,
                                        feeLoader: app.feeLoader,
                                        erc20SendValidator: app.erc20SendValidator,
                                        accountsUpdater: app.accountsUpdater)
        
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
