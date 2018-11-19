//
//  Created by Storiqa on 25/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class EmailConfirmModule {
    
    class func create(app: Application, token: String) -> EmailConfirmModuleInput {
        let router = EmailConfirmRouter(app: app)
        let presenter = EmailConfirmPresenter()
        
        let storyboard = UIStoryboard(name: "EmailConfirm", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "EmailConfirmVC") as! EmailConfirmViewController
        
        let interactor = EmailConfirmInteractor(token: token,
                                                emailConfirmProvider: app.emailConfirmNetworkProvider,
                                                authTokenDefaults: app.authTokenDefaultsProvider,
                                                signHeaderFactory: app.signHeaderFactory)

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
