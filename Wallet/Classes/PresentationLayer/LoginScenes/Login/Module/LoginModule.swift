//
//  Created by Storiqa on 17/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit
import FacebookLogin


class LoginModule {
    
    class func create() -> LoginModuleInput {
        let router = LoginRouter()
        let presenter = LoginPresenter()
        
        //Injections
        let defaultsProvider = DefaultsProvider()
        let socialVM = SocialNetworkAuthViewModel(facebookLoginManager: LoginManager())
        let biometricAuthProvider = BiometricAuthProvider(errorParser: BiometricAuthErrorParser())
        let loginNetworkProvider = LoginNetworkProvider()
        let userNetworkProvider = CurrentUserNetworkProvider()
        let userDataStore = UserDataStoreService()
        let accountsNetworkProvider = AccountsNetworkProvider()
        let accountsDataStore = AccountsDataStore()
        let interactor = LoginInteractor(socialViewVM: socialVM,
                                         defaultProvider: defaultsProvider,
                                         biometricAuthProvider: biometricAuthProvider,
                                         loginNetworkProvider: loginNetworkProvider,
                                         userNetworkProvider: userNetworkProvider,
                                         userDataStore: userDataStore,
                                         accountsNetworkProvider: accountsNetworkProvider,
                                         accountsDataStore: accountsDataStore)
        
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
