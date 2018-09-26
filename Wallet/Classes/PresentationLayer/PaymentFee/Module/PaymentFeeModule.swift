//
//  Created by Storiqa on 26/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PaymentFeeModule {
    
    class func create(sendProvider: SendTransactionBuilderProtocol) -> PaymentFeeModuleInput {
        let router = PaymentFeeRouter()
        let presenter = PaymentFeePresenter()
        let interactor = PaymentFeeInteractor(sendProvider: sendProvider)
        
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
