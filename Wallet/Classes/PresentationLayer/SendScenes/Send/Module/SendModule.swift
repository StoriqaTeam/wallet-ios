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
                                        sendTransactionNetworkProvider: app.sendTransactionNetworkProvider,
                                        userDataStoreService: app.userDataStoreService,
                                        authTokenProvider: app.authTokenProvider,
                                        accountsUpdater: app.accountsUpdater,
                                        txnUpdater: app.transactionsUpdater)
        
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
        
        let feeUpdateChannel = app.channelStorage.feeUpadteChannel
        interactor.setFeeUpdateChannelInput(feeUpdateChannel)
        app.feeProvider.setFeeUpdaterChannel(feeUpdateChannel)
        
        return presenter
    }
    
}
