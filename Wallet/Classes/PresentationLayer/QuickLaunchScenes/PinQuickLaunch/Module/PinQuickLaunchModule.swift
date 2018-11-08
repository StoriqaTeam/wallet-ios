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
    
    
    class func create(app: Application) -> PinQuickLaunchModuleInput {

        let provider = QuickLaunchProvider(defaultsProvider: app.defaultsProvider,
                                           keychainProvider: app.keychainProvider,
                                           biometricAuthProvider: app.biometricAuthProvider)

        return create(app: app, qiuckLaunchProvider: provider)
    }
    
}
