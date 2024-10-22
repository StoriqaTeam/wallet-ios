//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QuickLaunchModule {
    
    class func create(app: Application) -> QuickLaunchModuleInput {
        let router = QuickLaunchRouter(app: app)
        
        let baseFadeAnimator = app.transitionAnimatorFactory.createBaseFadeAnimator(duration: 1)
        let presenter = QuickLaunchPresenter(baseFadeAnimator: baseFadeAnimator)
        
        let biometricAuthProvider = app.biometricAuthProviderFactory.create()
        let quickLaunchProvider = QuickLaunchProvider(defaultsProvider: app.defaultsProvider,
                                                      keychainProvider: app.keychainProvider,
                                                      biometricAuthProvider: biometricAuthProvider)
        
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
