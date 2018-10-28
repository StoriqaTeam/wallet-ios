//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinQuickLaunchModule {
    
    class func create(app: Application, qiuckLaunchProvider: QuickLaunchProviderProtocol) -> PinQuickLaunchModuleInput {
        let router = PinQuickLaunchRouter(app: app)
        let presenter = PinQuickLaunchPresenter()
        let interactor = PinQuickLaunchInteractor(qiuckLaunchProvider: qiuckLaunchProvider)
        
        let storyboard = UIStoryboard(name: "PinQuickLaunch", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PinQuickLaunchVC") as! PinQuickLaunchViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
    
    class func create(app: Application, authData: AuthData, token: String) -> PinQuickLaunchModuleInput {
        //Injections
        let defaultsProvider = DefaultsProvider()
        let keychainProvider = KeychainProvider()
        let biometricAuthProvider = BiometricAuthProvider(errorParser: BiometricAuthErrorParser())
        let provider = QuickLaunchProvider(authData: authData,
                                           token: token,
                                           defaultsProvider: defaultsProvider,
                                           keychainProvider: keychainProvider,
                                           biometricAuthProvider: biometricAuthProvider)

        return create(app: app, qiuckLaunchProvider: provider)
    }
    
}
