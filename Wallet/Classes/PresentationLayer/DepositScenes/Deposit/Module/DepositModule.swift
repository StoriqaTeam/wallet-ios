//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class DepositModule {
    
    class func create(accountWatcher: CurrentAccountWatcherProtocol, user: User) -> DepositModuleInput {
        let router = DepositRouter()
        
        //Injections
        let qrProvider = QRCodeProvider()
        let dataStoreService = AccountsDataStore()
        let accountsProvider = AccountsProvider(dataStoreService: dataStoreService)
        let converterFactory = CurrecncyConverterFactory()
        let currencyFormatter = CurrencyFormatter()
        let accountTypeResolver = AccountTypeResolver()
        let accountDisplayer = AccountDisplayer(user: user,
                                                currencyFormatter: currencyFormatter,
                                                converterFactory: converterFactory,
                                                accountTypeResolver: accountTypeResolver)
        
        let presenter = DepositPresenter(accountDisplayer: accountDisplayer)
        let interactor = DepositInteractor(qrProvider: qrProvider,
                                           accountsProvider: accountsProvider,
                                           accountWatcher: accountWatcher)
        
        let depositVC = UIStoryboard(name: "Deposit", bundle: nil)
        let viewController = depositVC.instantiateViewController(withIdentifier: "depositVC") as! DepositViewController

        interactor.output = presenter
        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
