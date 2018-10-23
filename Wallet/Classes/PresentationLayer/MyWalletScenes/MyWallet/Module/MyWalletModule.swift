//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class MyWalletModule {
    
    class func create(tabBar: UITabBarController,
                      accountWatcher: CurrentAccountWatcherProtocol,
                      user: User) -> MyWalletModuleInput {
        let router = MyWalletRouter()
        
        // Injections
        let converterFactory = CurrecncyConverterFactory()
        let currencyFormatter = CurrencyFormatter()
        let dataStoreService = AccountsDataStore()
        let accountsProvider = AccountsProvider(dataStoreService: dataStoreService)
        let accountTypeResolver = AccountTypeResolver()
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: currencyFormatter,
                                                converterFactory: converterFactory,
                                                accountTypeResolver: accountTypeResolver)
        
        let presenter = MyWalletPresenter(user: user,
                                          accountDisplayer: accountDisplayer)
        presenter.mainTabBar = tabBar
        let interactor = MyWalletInteractor(accountsProvider: accountsProvider,
                                            accountWatcher: accountWatcher)
        
        let myWalletSb = UIStoryboard(name: "MyWallet", bundle: nil)
        let viewController = myWalletSb.instantiateViewController(withIdentifier: "myWalletVC") as! MyWalletViewController
        
        interactor.output = presenter
        
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
