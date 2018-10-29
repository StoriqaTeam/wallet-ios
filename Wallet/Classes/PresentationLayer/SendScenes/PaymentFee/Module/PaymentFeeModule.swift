//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PaymentFeeModule {
    
    class func create(app: Application, sendTransactionBuilder: SendProviderBuilderProtocol,
                      tabBar: UITabBarController) -> PaymentFeeModuleInput {
        let router = PaymentFeeRouter(app: app)

        let presenter = PaymentFeePresenter(currencyFormatter: app.currencyFormatter,
                                            currencyImageProvider: app.currencyImageProvider)
        presenter.mainTabBar = tabBar
        
        let interactor = PaymentFeeInteractor(sendTransactionBuilder: sendTransactionBuilder,
                                              sendTransactionNetworkProvider: app.sendTransactionNetworkProvider,
                                              userDataStoreService: app.userDataStoreService,
                                              authTokenProvider: app.authTokenProvider,
                                              accountsProvider: app.accountsProvider)
        
        let accountsVC = UIStoryboard(name: "PaymentFee", bundle: nil)
        let viewController = accountsVC.instantiateViewController(withIdentifier: "PaymentFeeVC") as! PaymentFeeViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
