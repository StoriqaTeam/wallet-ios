//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PaymentFeeModule {
    
    class func create(sendTransactionBuilder: SendProviderBuilderProtocol,
                      tabBar: UITabBarController) -> PaymentFeeModuleInput {
        let router = PaymentFeeRouter()
        let formatter = CurrencyFormatter()
        let converterFactory = CurrecncyConverterFactory()
        let currencyImageProvider = CurrencyImageProvider()
        
        let presenter = PaymentFeePresenter(currencyFormatter: formatter,
                                            converterFactory: converterFactory,
                                            currencyImageProvider: currencyImageProvider)
        presenter.mainTabBar = tabBar
        let interactor = PaymentFeeInteractor(sendTransactionBuilder: sendTransactionBuilder)
        
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
