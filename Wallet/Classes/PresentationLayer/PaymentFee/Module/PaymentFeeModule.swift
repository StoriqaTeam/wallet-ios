//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PaymentFeeModule {
    
    class func create(sendTransactionBuilder: SendProviderBuilderProtocol) -> PaymentFeeModuleInput {
        let router = PaymentFeeRouter()
        let formatter = CurrencyFormatter()
        let converterFactory = CurrecncyConverterFactory()
        
        let presenter = PaymentFeePresenter(currencyFormatter: formatter, converterFactory: converterFactory)
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
