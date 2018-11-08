//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QuickLaunchModule {
    
    class func create(app: Application) -> QuickLaunchModuleInput {
        let router = QuickLaunchRouter(app: app)
        let presenter = QuickLaunchPresenter()
        
        let quickLaunchProvider = QuickLaunchProvider(defaultsProvider: app.defaultsProvider,
                                           keychainProvider: app.keychainProvider,
                                           biometricAuthProvider: app.biometricAuthProvider)
        
        let interactor = QuickLaunchInteractor(qiuckLaunchProvider: quickLaunchProvider)
        
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
