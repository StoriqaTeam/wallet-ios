//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ProfileModule {
    
    class func create(app: Application) -> ProfileModuleInput {
        let router = ProfileRouter(app: app)
        let presenter = ProfilePresenter()
        
        let interactor = ProfileInteractor(defaults: app.defaultsProvider,
                                           keychain: app.keychainProvider,
                                           userStoreService: app.userDataStoreService)
        
        let accountsVC = UIStoryboard(name: "Profile", bundle: nil)
        let viewController = accountsVC.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
