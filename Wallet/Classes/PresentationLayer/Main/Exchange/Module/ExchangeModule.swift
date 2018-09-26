//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeModule {
    
    class func create(account: Account) -> ExchangeModuleInput {
        let router = ExchangeRouter()
        let presenter = ExchangePresenter()
        
        let accountsProvider = FakeAccountProvider()
        let transactionsProvider = FakeTransactionsProvider()
        let accountLinker = FakeAccountLinker(fakeAccProvider: accountsProvider, fakeTxProvider: transactionsProvider)
        
        let interactor = ExchangeInteractor(accountsLinker: accountLinker, account: account)
        
        let exchangeSb = UIStoryboard(name: "Exchange", bundle: nil)
        let viewController = exchangeSb.instantiateViewController(withIdentifier: "exchangeVC") as! ExchangeViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
    class func create() -> ExchangeModuleInput {
        let router = ExchangeRouter()
        let presenter = ExchangePresenter()
        
        let accountsProvider = FakeAccountProvider()
        let transactionsProvider = FakeTransactionsProvider()
        let accountLinker = FakeAccountLinker(fakeAccProvider: accountsProvider, fakeTxProvider: transactionsProvider)
        let interactor = ExchangeInteractor(accountsLinker: accountLinker, account: nil)
        
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
