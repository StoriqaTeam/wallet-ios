//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeModule {
    
    class func create(accountWatcher: CurrentAccountWatcherProtocol) -> ExchangeModuleInput {
        let router = ExchangeRouter()
        
        // Injections
        let converterFactory = CurrecncyConverterFactory()
        let currencyFormatter = CurrencyFormatter()
        let feeWaitProvider = FakePaymentFeeAndWaitProvider()
        let accountsProvider = FakeAccountProvider()
        
        let presenter = ExchangePresenter(converterFactory: converterFactory, currencyFormatter: currencyFormatter)
        let interactor = ExchangeInteractor(accountWatcher: accountWatcher,
                                            accountsProvider: accountsProvider,
                                            converterFactory: converterFactory,
                                            feeWaitProvider: feeWaitProvider)
        
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
