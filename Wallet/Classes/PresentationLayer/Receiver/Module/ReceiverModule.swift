//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ReceiverModule {
    
    class func create(sendProvider: SendTransactionBuilderProtocol) -> ReceiverModuleInput {
        let router = ReceiverRouter()
        let presenter = ReceiverPresenter()
        
        //Injections
        let deviceContactsProvider = DeviceContactsProvider()
        let interactor = ReceiverInteractor(deviceContactsProvider: deviceContactsProvider,
                                            sendProvider: sendProvider)
        
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
