//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeModule {
    
    class func create(app: Application, accountWatcher: CurrentAccountWatcherProtocol) -> ExchangeModuleInput {
        let router = ExchangeRouter(app: app)
        let presenter = ExchangePresenter(converterFactory: app.currencyConverterFactory,
                                          currencyFormatter: app.currencyFormatter,
                                          accountDisplayer: app.accountDisplayer)
        
        let exchangeProviderBuilder = app.exchangeProviderBuilderFactory.create()
        let interactor = ExchangeInteractor(accountsProvider: app.accountsProvider,
                                            accountWatcher: accountWatcher,
                                            exchangeProviderBuilder: exchangeProviderBuilder,
                                            sendTransactionService: app.sendTransactionService,
                                            signHeaderFactory: app.signHeaderFactory,
                                            authTokenprovider: app.authTokenProvider,
                                            userDataStoreService: app.userDataStoreService,
                                            exchangeRatesLoader: app.exchangeLoader,
                                            orderFactory: app.orderFactory,
                                            orderObserver: app.orderObserver)
        
        let exchangeSb = UIStoryboard(name: "Exchange", bundle: nil)
        let viewController = exchangeSb.instantiateViewController(withIdentifier: "exchangeVC") as! ExchangeViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        // MARK: - Channels
        let accountsUpdateChannel = app.channelStorage.accountsUpadteChannel
        let expiredOrderChannel = app.channelStorage.orderExpiredChannel
        let orderTickChannel = app.channelStorage.orderTickChannel
        
        app.accountsProvider.setAccountsUpdaterChannel(accountsUpdateChannel)
        interactor.setAccountsUpdateChannelInput(accountsUpdateChannel)
        interactor.setOrderExpiredChannelInput(expiredOrderChannel)
        interactor.setOrderTickChannelInput(orderTickChannel)
        
        return presenter
    }
    
}
