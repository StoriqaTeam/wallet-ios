//
//  Created by Storiqa on 22/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ExchangeConfirmPopUpModule {
    
    class func create(fromAccount: String,
                      toAccount: String,
                      amount: String,
                      confirmTxBlock: @escaping (() -> Void)) -> ExchangeConfirmPopUpModuleInput {
        let router = ExchangeConfirmPopUpRouter()
        let presenter = ExchangeConfirmPopUpPresenter(fromAccount: fromAccount,
                                                      toAccount: toAccount,
                                                      amount: amount,
                                                      confirmTxBlock: confirmTxBlock)
        let interactor = ExchangeConfirmPopUpInteractor()
        
        let sendSb = UIStoryboard(name: "ExchangeConfirmPopUp", bundle: nil)
        let viewController = sendSb.instantiateViewController(withIdentifier: "ExchangeConfirmPopUpVC")
            as! ExchangeConfirmPopUpViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
