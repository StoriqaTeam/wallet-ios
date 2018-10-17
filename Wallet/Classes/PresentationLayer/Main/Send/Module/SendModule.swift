//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendModule {
    
    class func create(accountWatcher: CurrentAccountWatcherProtocol,
                      user: User,
                      tabBar: UITabBarController) -> SendModuleInput {
        let router = SendRouter()
        
        //Injections
        let converterFactory = CurrecncyConverterFactory()
        let formatter = CurrencyFormatter()
        let accountProvider = FakeAccountProvider()
        
        let sendTxBuilder = SendTransactionBuilder()
        let currencyImageProvider = CurrencyImageProvider()
        let accountTypeResolver = AccountTypeResolver()
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: formatter,
                                                converterFactory: converterFactory,
                                                accountTypeResolver: accountTypeResolver)
        
        let presenter = SendPresenter(currencyFormatter: formatter,
                                      currencyImageProvider: currencyImageProvider,
                                      accountDisplayer: accountDisplayer)
        presenter.mainTabBar = tabBar
        let interactor = SendInteractor(sendTransactionBuilder: sendTxBuilder,
                                        accountsProvider: accountProvider,
                                        accountWatcher: accountWatcher)
        
        let sendSb = UIStoryboard(name: "Send", bundle: nil)
        let viewController = sendSb.instantiateViewController(withIdentifier: "sendVC") as! SendViewController
        
        interactor.output = presenter
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
