//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit

enum AuthData {
    case email(email: String, password: String)
    case socialProvider(provider: SocialNetworkTokenProvider, token: String)
}

class QuickLaunchModule {
    
    class func create(authData: AuthData, token: String) -> QuickLaunchModuleInput {
        let router = QuickLaunchRouter()
        let presenter = QuickLaunchPresenter()
        
        //Injections
        let keychainProvider = KeychainProvider()
        let biometricAuthProvider = BiometricAuthProvider(errorParser: BiometricAuthErrorParser())
        let provider = QuickLaunchProvider(authData: authData, token: token, keychainProvider: keychainProvider, biometricAuthProvider: biometricAuthProvider)
        let interactor = QuickLaunchInteractor(qiuckLaunchProvider: provider)
        
        let storyboard = UIStoryboard(name: "QuickLaunch", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "QuickLaunchVC") as! QuickLaunchViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
