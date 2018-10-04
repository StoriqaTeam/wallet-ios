//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ReceiverModule {
    
    class func create(sendTransactionBuilder: SendProviderBuilderProtocol) -> ReceiverModuleInput {
        let router = ReceiverRouter()
        
        //Injections
        let deviceContactsProvider = DeviceContactsProvider()
        let formatter = CurrencyFormatter()
        let converterFactory = CurrecncyConverterFactory()
        
        let interactor = ReceiverInteractor(deviceContactsProvider: deviceContactsProvider, sendTransactionBuilder: sendTransactionBuilder)
        let presenter = ReceiverPresenter(currencyFormatter: formatter, converterFactory: converterFactory)
        
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
