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
                                                accountTypeResolver: app.accountTypeResolver)
        
        let presenter = SendPresenter(currencyFormatter: app.currencyFormatter,
                                      currencyImageProvider: app.currencyImageProvider,
                                      accountDisplayer: accountDisplayer)
        presenter.mainTabBar = tabBar
        let interactor = SendInteractor(sendTransactionBuilder: app.sendTransactionBuilder,
                                        accountsProvider: app.accountsProvider,
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
