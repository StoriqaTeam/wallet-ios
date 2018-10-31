//
//  Created by Storiqa on 18/09/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class FirstLaunchModule {
    
    class func create(app: Application) -> FirstLaunchModuleInput {
        let router = FirstLaunchRouter(app: app)
        let presenter = FirstLaunchPresenter()
        let interactor = FirstLaunchInteractor()
        
        let firstLaunchSb = UIStoryboard(name: "FirstLaunch", bundle: nil)
        let viewController = firstLaunchSb.instantiateViewController(withIdentifier: "FirstLaunchVC") as! FirstLaunchViewController

        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
