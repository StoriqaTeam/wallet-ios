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
        
        let interactor = LoginInteractor(socialViewVM: socialVM,
                                         defaultProvider: app.defaultsProvider,
                                         biometricAuthProvider: app.biometricAuthProvider,
                                         userDataStore: app.userDataStoreService,
                                         keychain: app.keychainProvider,
                                         loginService: app.loginService)
        
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
