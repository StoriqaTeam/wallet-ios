//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import FacebookLogin


class LoginModule {
    
    class func create(app: Application) -> LoginModuleInput {
        let router = LoginRouter(app: app)
        let presenter = LoginPresenter()
        
        let socialVM = SocialNetworkAuthViewModel(facebookLoginManager: app.facebookLoginManager)
        
        let authTokenDefaultsProvider = AuthTokenDefaultsProvider()
        let interactor = LoginInteractor(socialViewVM: socialVM,
                                         defaultProvider: app.defaultsProvider,
                                         authTokenDefaultsProvider: authTokenDefaultsProvider,
                                         biometricAuthProvider: app.biometricAuthProvider,
                                         loginNetworkProvider: app.loginNetworkProvider,
                                         userNetworkProvider: app.userNetworkProvider,
                                         userDataStore: app.userDataStoreService,
                                         keychain: app.keychainProvider,
                                         accountsNetworkProvider: app.accountsNetworkProvider,
                                         accountsDataStore: app.accountsDataStoreService)
        
        let loginSb = UIStoryboard(name: "Login", bundle: nil)
        let viewController = loginSb.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        
        interactor.output = presenter
        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
