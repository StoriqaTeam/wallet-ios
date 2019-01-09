//
//  Created by Storiqa on 19/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class RecipientAccountsModule {
    
    class func create(app: Application, exchangeProviderBuilder: ExchangeProviderBuilderProtocol) -> RecipientAccountsModuleInput {
        let router = RecipientAccountsRouter()
        
        let presenter = RecipientAccountsPresenter(accountDisplayer: app.accountDisplayer)
        let interactor = RecipientAccountsInteractor(exchangeProviderBuilder: exchangeProviderBuilder)
        
        let storyboard = UIStoryboard(name: "RecipientAccounts", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RecipientAccountsVC")
            as! RecipientAccountsViewController
        
        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
