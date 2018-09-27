//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class SendModule {
    
    class func create(account: Account? = nil) -> SendModuleInput {
        let router = SendRouter()
        let presenter = SendPresenter()
        
        //Injections
        let converterFactory = CurrecncyConverterFactory()
        let formatter = CurrencyFormatter()
        let sendProvider = SendTransactionBuilder(converterFactory: converterFactory, currencyFormatter: formatter)
        let fakeAccountsProvider = FakeAccountProvider()
        let interactor = SendInteractor(sendProvider: sendProvider, accountsProvider: fakeAccountsProvider, account: account)
        
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
