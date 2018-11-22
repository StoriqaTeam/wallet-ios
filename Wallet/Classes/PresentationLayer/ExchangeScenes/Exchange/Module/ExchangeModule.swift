//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeModule {
    
    class func create(app: Application, accountWatcher: CurrentAccountWatcherProtocol, user: User) -> ExchangeModuleInput {
        let router = ExchangeRouter(app: app)
        
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: app.currencyFormatter,
                                                converterFactory: app.currencyConverterFactory,
                                                accountTypeResolver: app.accountTypeResolver,
                                                denominationUnitsConverter: app.denominationUnitsConverter)
        
        let presenter = ExchangePresenter(converterFactory: app.currencyConverterFactory,
                                          currencyFormatter: app.currencyFormatter,
                                          accountDisplayer: accountDisplayer)
        
        let exchangeProviderBuilder = app.exchangeProviderBuilderFactory.create()
        let interactor = ExchangeInteractor(accountsProvider: app.accountsProvider,
                                            accountWatcher: accountWatcher,
                                            exchangeProviderBuilder: exchangeProviderBuilder,
                                            sendTransactionService: app.sendTransactionService,
                                            signHeaderFactory: app.signHeaderFactory,
                                            authTokenprovider: app.authTokenProvider,
                                            userDataStoreService: app.userDataStoreService,
                                            exchangeRatesLoader: app.exchangeLoader)
        
        let exchangeSb = UIStoryboard(name: "Exchange", bundle: nil)
        let viewController = exchangeSb.instantiateViewController(withIdentifier: "exchangeVC") as! ExchangeViewController
        
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
