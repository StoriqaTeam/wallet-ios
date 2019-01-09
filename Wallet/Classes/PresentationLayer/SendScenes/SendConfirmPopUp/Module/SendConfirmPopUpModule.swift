//
//  Created by Storiqa on 14/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendConfirmPopUpModule {
    
    class func create(address: String,
                      amount: String,
                      fee: String,
                      total: String,
                      confirmTxBlock: @escaping (() -> Void)) -> SendConfirmPopUpModuleInput {
        
        let router = SendConfirmPopUpRouter()
        let presenter = SendConfirmPopUpPresenter(address: address,
                                                  amount: amount,
                                                  fee: fee,
                                                  total: total,
                                                  confirmTxBlock: confirmTxBlock)
        let interactor = SendConfirmPopUpInteractor()
        
        let sendSb = UIStoryboard(name: "SendConfirmPopUp", bundle: nil)
        let viewController = sendSb.instantiateViewController(withIdentifier: "SendConfirmPopUpVC") as! SendConfirmPopUpViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
