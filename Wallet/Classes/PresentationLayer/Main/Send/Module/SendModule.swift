//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendModule {
    
    class func create(accountWatcher: CurrentAccountWatcherProtocol) -> SendModuleInput {
        let router = SendRouter()
        let presenter = SendPresenter()
        
        //Injections
        let converterFactory = CurrecncyConverterFactory()
        let formatter = CurrencyFormatter()
        let accountProvider = FakeAccountProvider()
        let sendProvider = SendTransactionProvider(converterFactory: converterFactory,
                                                   currencyFormatter: formatter,
                                                   accountProvider: accountProvider)
        let sendTxBuilder = SendTransactionBuilder(defaultSendTxProvider: sendProvider)
        
        let fakeAccountsProvider = FakeAccountProvider()
        let interactor = SendInteractor(sendTransactionBuilder: sendTxBuilder,
                                        accountsProvider: fakeAccountsProvider,
                                        accountWatcher: accountWatcher)
        
        let sendSb = UIStoryboard(name: "Send", bundle: nil)
        let viewController = sendSb.instantiateViewController(withIdentifier: "sendVC") as! SendViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }

}
