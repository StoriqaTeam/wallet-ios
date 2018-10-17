//
//  Created by Storiqa on 25/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ReceiverModule {
    
    class func create(sendTransactionBuilder: SendProviderBuilderProtocol,
                      tabBar: UITabBarController) -> ReceiverModuleInput {
        let router = ReceiverRouter()
        
        //Injections
        let deviceContactsFetcher = DeviceContactsFetcher()
        let formatter = CurrencyFormatter()
        let converterFactory = CurrecncyConverterFactory()
        let currencyImageProvider = CurrencyImageProvider()
        let contactsSorter = ContactsSorter()
        let contactsMapper = ContactsMapper()
        
        let interactor = ReceiverInteractor(deviceContactsFetcher: deviceContactsFetcher,
                                            sendTransactionBuilder: sendTransactionBuilder,
                                            contactsSorter: contactsSorter,
                                            contactsMapper: contactsMapper)
        let presenter = ReceiverPresenter(currencyFormatter: formatter,
                                          converterFactory: converterFactory,
                                          currencyImageProvider: currencyImageProvider)
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
