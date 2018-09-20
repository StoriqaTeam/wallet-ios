//
//  Created by Storiqa on 20/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class PinQuickLaunchModule {
    
    class func create(qiuckLaunchProvider: QuickLaunchProviderProtocol) -> PinQuickLaunchModuleInput {
        let router = PinQuickLaunchRouter()
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
    
}
