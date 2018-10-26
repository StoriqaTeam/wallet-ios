//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EmailConfirmModule {
    
    class func create(token: String) -> EmailConfirmModuleInput {
        let router = EmailConfirmRouter()
        let presenter = EmailConfirmPresenter()
        
        let storyboard = UIStoryboard(name: "EmailConfirm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EmailConfirmVC") as! EmailConfirmViewController
        
        let emailConfirmProvider = EmailConfirmNetworkProvider()
        let authTokenDefaults = AuthTokenDefaultsProvider()
        let interactor = EmailConfirmInteractor(token: token,
                                                emailConfirmProvider: emailConfirmProvider,
                                                authTokenDefaults: authTokenDefaults)

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
