//
//  Created by Storiqa on 01/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ChangePasswordModule {
    
    class func create(app: Application) -> ChangePasswordModuleInput {
        let router = ChangePasswordRouter()
        let presenter = ChangePasswordPresenter()
        let interactor = ChangePasswordInteractor(authTokenDefaultsProvider: app.authTokenDefaultsProvider,
                                                  authTokenProvider: app.authTokenProvider,
                                                  networkProvider: app.changePasswordNetworkProvider,
                                                  signHeaderFactory: app.signHeaderFactory,
                                                  userDataStoreService: app.userDataStoreService)
        
        let changePasswordSb = UIStoryboard(name: "ChangePassword", bundle: nil)
        let viewController = changePasswordSb.instantiateViewController(withIdentifier: "ChangePasswordVC")
            as! ChangePasswordViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
