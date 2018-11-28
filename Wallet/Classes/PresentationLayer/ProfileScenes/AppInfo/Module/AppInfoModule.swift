//
//  Created by Storiqa on 28/11/2018.
//  Copyright © 2018 Storiqa. All rights reserved.
//

import UIKit


class AppInfoModule {
    
    class func create() -> AppInfoModuleInput {
        let router = AppInfoRouter()
        let presenter = AppInfoPresenter()
        let interactor = AppInfoInteractor()
        
        let storyboard = UIStoryboard(name: "AppInfo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AppInfoVC")
            as! AppInfoViewController
        
        interactor.output = presenter

        viewController.output = presenter

        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return presenter
    }
    
}
