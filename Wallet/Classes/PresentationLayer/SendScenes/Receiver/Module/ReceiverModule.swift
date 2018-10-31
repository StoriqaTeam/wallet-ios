//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ReceiverModule {
    
    class func create(app: Application,
                      sendTransactionBuilder: SendProviderBuilderProtocol,
                      tabBar: UITabBarController) -> ReceiverModuleInput {
        
        let router = ReceiverRouter(app: app)
        
        let interactor = ReceiverInteractor(sendTransactionBuilder: sendTransactionBuilder,
                                            contactsProvider: app.contactsProvider,
                                            contactsUpdater: app.contactsChacheUpdater,
                                            cryptoAddressResolver: app.cryptoAddressResolver)
        
        let presenter = ReceiverPresenter(currencyFormatter: app.currencyFormatter,
                                          converterFactory: app.currencyConverterFactory,
                                          currencyImageProvider: app.currencyImageProvider,
                                          contactsMapper: app.contactsMapper,
                                          contactsSorter: app.contactsSorter)
        presenter.mainTabBar = tabBar
        
        let accountsVC = UIStoryboard(name: "Receiver", bundle: nil)
        let viewController = accountsVC.instantiateViewController(withIdentifier: "ReceiverVC") as! ReceiverViewController
        
        interactor.output = presenter
        viewController.output = presenter
        
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
