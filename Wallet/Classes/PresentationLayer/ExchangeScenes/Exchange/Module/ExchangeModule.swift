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
                                                accountTypeResolver: app.accountTypeResolver)
        
        let presenter = ExchangePresenter(converterFactory: app.currencyConverterFactory,
                                          currencyFormatter: app.currencyFormatter,
                                          accountDisplayer: accountDisplayer)
        
        let interactor = ExchangeInteractor(accountWatcher: accountWatcher,
                                            accountsProvider: app.accountsProvider,
                                            converterFactory: app.currencyConverterFactory,
                                            feeWaitProvider: app.fakePaymentFeeAndWaitProvider)
        
        let exchangeSb = UIStoryboard(name: "Exchange", bundle: nil)
        let viewController = exchangeSb.instantiateViewController(withIdentifier: "exchangeVC") as! ExchangeViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
