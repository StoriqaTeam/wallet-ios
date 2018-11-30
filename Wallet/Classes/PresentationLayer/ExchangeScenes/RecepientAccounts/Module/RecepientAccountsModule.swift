//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class RecepientAccountsModule {
    
    class func create(app: Application, exchangeProviderBuilder: ExchangeProviderBuilderProtocol) -> RecepientAccountsModuleInput {
        let router = RecepientAccountsRouter()
        
        let presenter = RecepientAccountsPresenter(accountDisplayer: app.accountDisplayer)
        let interactor = RecepientAccountsInteractor(exchangeProviderBuilder: exchangeProviderBuilder)
        
        let storyboard = UIStoryboard(name: "RecepientAccounts", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecepientAccountsVC")
            as! RecepientAccountsViewController
        
        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
