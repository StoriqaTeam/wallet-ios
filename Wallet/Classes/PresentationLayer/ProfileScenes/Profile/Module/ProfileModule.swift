//
//  Created by Storiqa on 08/10/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class ProfileModule {
    
    class func create() -> ProfileModuleInput {
        let router = ProfileRouter()
        let presenter = ProfilePresenter()
        
        let defaultProvider = DefaultsProvider()
        let keychainProvider = KeychainProvider()
        let userStoreService = UserDataStoreService()
        let interactor = ProfileInteractor(defaults: defaultProvider,
                                           keychain: keychainProvider,
                                           userStoreService: userStoreService)
        
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
