//
//  Created by Storiqa on 19/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class QuickLaunchModule {
    
    class func create() -> QuickLaunchModuleInput {
        let router = QuickLaunchRouter()
        let presenter = QuickLaunchPresenter()
        let interactor = QuickLaunchInteractor()
        let viewController = QuickLaunchViewController()

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
